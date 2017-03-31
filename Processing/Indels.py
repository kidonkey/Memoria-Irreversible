import json
from pprint import pprint
from itertools import islice
import matplotlib.pyplot as plt
import numpy as np
from os import listdir


def import_json(n):
    print(reproduce(get_changelog(n + '.txt'), 0))
    save_changelog(n + '.csv', get_changelog(n + '.txt'))
    print('IMPORT SUCCESSFUL!')


def get_changelog(path):
    """Takes the path to a Google Docs history json and returns its changelog as a list of tuples."""
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
    """Intakes a changelog and saves it in '/changelogs' with the name given."""
    f = open('../changelogs/' + name, mode='w', encoding="utf8")
    for l in changelog:
        if l[1] == 'delete':
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + str(l[3]) + '\n')
        else:
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + repr(str(l[3])) + '\n')
    f.flush()
    f.close()


def chars_indels(name, changelog):
    """Draws a characters vs. indels, accumulated-positions curve graph and saves it to '../chars-indels'."""
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
    plt.plot(np.array(cum))
    plt.ylabel('Characters')
    plt.xlabel('Indels')
    plt.plot(pos)
    fig = plt.gcf()
    fig.canvas.set_window_title(name)
    plt.savefig('../chars-indels/'+name + '.png', bbox_inches='tight')
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
    plt.plot(ts, np.array(cum))
    plt.plot(ts, pos)
    plt.savefig('../time_graph/' + name + '.pdf', bbox_inches='tight')
    plt.clf()


def reproduce(changelog, indels):
    """Given a changelog, returns string of changes accumulated up to indels or final state if indels is 0."""
    text = ''
    if indels == 0 or indels > len(changelog):
        indels = len(changelog)
    for i in range(indels):
        type = changelog[i][1]
        if type == 'insert':
            ibi = changelog[i][2]
            text = text[:ibi - 1] + changelog[i][3] + text[ibi - 1:]
        if type == 'delete':
            text = text[:changelog[i][2] - 1] + text[changelog[i][3]:]
    return text


def save_all_changelogs():
    """Get every changelog in '/data' and save it as a CSV in '/changelogs'."""
    for file in listdir("../data"):
        print(file)
        save_changelog(file[:2] + '.csv', get_changelog(file))


for dir in listdir("../data")[1:]:
    time_graph(dir[:2],get_changelog(dir))

    #chars_indels('40',get_changelog(file))


#for n in range(41, 61):
#    print(str(n))
#    cl = get_changelog(str(n)+'.txt')
#    save_changelog(str(n)+'.csv', cl)
#for file in listdir("../data"):
#     print(file)
#    cl = get_changelog(file)
#    graph(file[:2], cl)

