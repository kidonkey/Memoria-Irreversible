import json
from pprint import pprint
from itertools import islice
import matplotlib.pyplot as plt
import numpy as np
from os import listdir


def get_changelog(path):
    changelog = []

    def parse_mlti(mts, timestamp):
        for i in range(len(mts)):
            if mts[i]['ty'] == 'is':
                changelog.append((timestamp, 'insert', mts[i]['ibi'], mts[i]['s']))
                # print(mts[i]['ibi'], mts[i]['s'])
            elif mts[i]['ty'] == 'ds':
                changelog.append((timestamp, 'delete', mts[i]['si'], mts[i]['ei']))
                # print(mts[i]['si'], mts[i]['ei'])
            elif mts[i]['ty'] == 'mlti':
                parse_mlti(mts[i]['mts'], timestamp)
            else:
                continue

    with open("../data/" + path, 'rt', encoding="utf8") as f:
        for l in islice(f, 1):
            # print(l)
            data = json.loads(l)
            # print(json.dumps(data,indent=2, separators=(',', ': ')))
            for i in range(len(data['changelog'])):  # timestamp
                timestamp = data['changelog'][i][1]
                # print('timestamp:', timestamp)
                if data['changelog'][i][0]['ty'] == 'is':
                    pos = data['changelog'][i][0]['ibi']
                    s = data['changelog'][i][0]['s']
                    # print(pos, s)
                    changelog.append((timestamp, 'insert', pos, s))
                if data['changelog'][i][0]['ty'] == 'ds':
                    start = data['changelog'][i][0]['si']
                    end = data['changelog'][i][0]['ei']
                    # print(start, end)
                    changelog.append((timestamp, 'delete', start, end))
                if data['changelog'][i][0]['ty'] == 'mlti':
                    parse_mlti(data['changelog'][i][0]['mts'], timestamp)
    return changelog


def save_changelog(name, changelog):
    f = open('../changelogs/' + name, mode='w', encoding="utf8")
    for l in changelog:
        if l[1] == 'deletion':
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + str(l[3]) + '\n')
        else:
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + repr(str(l[3])) + '\n')
    f.flush()
    f.close()


def graph(name, changelog):
    cum = [0]
    ins = [0]
    dls = [0]
    pos = [0]
    for x in range(len(changelog)):
        if changelog[x][1] == 'insert':
            cum.append(cum[x] + len(changelog[x][3]))
            ins.append(ins[x] + len(changelog[x][3]))
            dls.append(dls[x])
        if changelog[x][1] == 'delete':
            cum.append(cum[x] - (changelog[x][3] - changelog[x][2] + 1))
            ins.append(ins[x])
            dls.append(changelog[x][3] - changelog[x][2] + 1)
        pos.append(changelog[x][2])
    # plt.plot(ins)
    plt.plot(np.array(cum))
    # plt.plot(np.array(cum)-np.array(ins))
    plt.plot(pos)
    # plt.plot(np.array(cum)-np.array(dls))
    plt.savefig('../pos_graph/' + name + '.png', bbox_inches='tight')
    plt.clf()


def time_graph(name, changelog):
    ts = [changelog[0][0]]
    cum = [0]
    ins = [0]
    dls = [0]
    pos = [0]
    for x in range(len(changelog)):
        if changelog[x][1] == 'insert':
            cum.append(cum[x] + len(changelog[x][3]))
            ins.append(ins[x] + len(changelog[x][3]))
            dls.append(dls[x])
        if changelog[x][1] == 'delete':
            cum.append(cum[x] - (changelog[x][3] - changelog[x][2] + 1))
            ins.append(ins[x])
            dls.append(changelog[x][3] - changelog[x][2] + 1)
        pos.append(changelog[x][2])
        ts.append(changelog[x][0])
    # plt.plot(ins)
    plt.plot(ts, np.array(cum))
    # plt.plot(np.array(cum)-np.array(ins))
    plt.plot(ts, pos)
    # plt.plot(np.array(cum)-np.array(dls))
    plt.savefig('../time_graph/' + name + '.png', bbox_inches='tight')
    plt.clf()


def recover_text(changelog):
    text = ''
    for i in range(len(changelog)):
        type = changelog[i][1]
        if type == 'insert':
            ibi = changelog[i][2]
            text = text[:ibi - 1] + changelog[i][3] + text[ibi - 1:]
        if type == 'delete':
            text = text[:changelog[i][2] - 1] + text[changelog[i][3]:]
    return text


def get_all_changelogs():
    for file in listdir("../data"):
        print(file)
        save_changelog(file[:2] + '.csv', get_changelog(file))

cl = get_changelog('52.txt')
t = recover_text(cl)
print(t)

"""""""""
log = []
ibis = 1
change = ''
si = 1
ei = 1
for i in range(len(changelog) - 1):
    if changelog[i][1] == changelog[i + 1][1] == 'insertion' and changelog[i][2] == changelog[i+1][2]-len(changelog[i][3]):
        change += changelog[i + 1][3]
    elif changelog[i][1] != changelog[i + 1][1] and changelog[i][1] == 'insertion':
        log.append((changelog[i][0], changelog[i][1], changelog[i][2], change+changelog[i][3]))
        si = changelog[i+1][2]
        ei = changelog[i+1][3]
    elif changelog[i][1] == changelog[i + 1][1] == 'deletion' and changelog[i][2]-changelog[i][3]+1 == changelog[i+1][2]:
        ei = changelog
pprint(log)
"""""""""
