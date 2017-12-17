import json
from pprint import pprint
from itertools import islice
import matplotlib.pyplot as plt
import numpy as np
from os import listdir
from nltk import word_tokenize
from nltk.stem import SnowballStemmer
import re
from collections import Counter


def import_json(n):
    print(reproduce(get_changelog(n + '.txt'), 0))
    save_changelog(n + '.csv', get_changelog(n + '.txt'))
    print('IMPORT SUCCESSFUL!')


def get_changelog(path):
    """Takes the path to a Google Docs history json and returns its changelog as a list of tuples."""
    changelog = []

    def parse_mlti(mts, timestamp, user):
        for i in range(len(mts)):
            if mts[i]['ty'] == 'is':
                changelog.append((timestamp, user, 'insert', mts[i]['ibi'], mts[i]['s']))
                # print(mts[i]['ibi'], mts[i]['s'])
            elif mts[i]['ty'] == 'ds':
                changelog.append((timestamp, user, 'delete', mts[i]['si'], mts[i]['ei']))
                # print(mts[i]['si'], mts[i]['ei'])
            elif mts[i]['ty'] == 'mlti':
                parse_mlti(mts[i]['mts'], timestamp, user)
            else:
                continue

    with open("../data_raw/" + path, 'rt', encoding="utf8") as f:
        for l in islice(f, 3):
            print(l)
            if ')]}' in l:
                continue
            data = json.loads(l)
            # print(json.dumps(data,indent=2, separators=(',', ': ')))
            for i in range(len(data['changelog'])):  # timestamp
                timestamp = data['changelog'][i][1]
                user = data['changelog'][i][4]
                # print('timestamp:', timestamp)
                if data['changelog'][i][0]['ty'] == 'is':
                    pos = data['changelog'][i][0]['ibi']
                    s = data['changelog'][i][0]['s']
                    # print(pos, s)
                    changelog.append((timestamp, user, 'insert', pos, s))
                if data['changelog'][i][0]['ty'] == 'ds':
                    start = data['changelog'][i][0]['si']
                    end = data['changelog'][i][0]['ei']
                    # print(start, end)
                    changelog.append((timestamp, user, 'delete', start, end))
                if data['changelog'][i][0]['ty'] == 'mlti':
                    parse_mlti(data['changelog'][i][0]['mts'], timestamp, user)
    return changelog


def group(changelog):
    for i in range(len(changelog)):




def save_changelog(name, changelog):
    """Intakes a changelog and saves it in '/data_preprocessed' with the name given."""
    f = open('../data_preprocessed/' + name + '.csv', mode='w', encoding="utf8")
    for l in changelog:
        if l[2] == 'delete':
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + str(l[3]) + ',' + str(l[4]) + '\n')
        else:
            f.write(str(l[0]) + ',' + str(l[1]) + ',' + str(l[2]) + ',' + str(l[3]) + ',' + repr(str(l[4])) + '\n')
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
    plt.ylabel('Characters/Position')
    plt.xlabel('Indels')
    plt.plot(pos)
    fig = plt.gcf()
    fig.canvas.set_window_title(name)
    plt.savefig('../chars-indels/' + name + '.png', bbox_inches='tight')
    plt.clf()


def time_graph(id):
    d = get_info(id)
    changelog = get_changelog(id + '.txt')
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
    plt.xlabel("Time")
    plt.ylabel('Characters/Position')
    plt.title(id + ' ' + d[2])
    plt.savefig('../time_graph/' + id + '.png', bbox_inches='tight')
    plt.clf()


def reproduce(changelog, indels=0):
    """Given a changelog, returns string of changes accumulated up to indels or final state if indels is 0."""
    text = ''
    if indels == 0 or indels > len(changelog):
        indels = len(changelog)
    for i in range(indels):
        text = apply_change(text, changelog[i])
    return text


def apply_change(text, change):
    type = change[1]
    ibi = change[2]
    content = change[3]
    if type == 'insert':
        changed = text[:ibi - 1] + content + text[ibi - 1:]
    if type == 'delete':
        changed = text[:ibi - 1] + text[content:]
    return changed


def list_data():
    return listdir("../data_raw")[1:]


def get_info(id=''):
    with open("../data.csv", 'rt', encoding="utf8") as f:
        lines = f.readlines()
        data = dict()
        for line in lines:
            d = line.split(',')
            data[d[0]] = d[1:]
    if id != '':
        if id in data:
            return data[id]
        else:
            return None
    return data


def plot_deviation(name, changelog):
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
        pos.append(changelog[x][2] - x)
    # plt.plot(np.array(cum))
    plt.ylabel('Cusum')
    plt.xlabel('Indels')
    plt.plot(pos)
    fig = plt.gcf()
    fig.canvas.set_window_title(name)
    plt.savefig('../deviation/' + name + '.png', bbox_inches='tight')
    plt.clf()


def cusum(name, changelog):
    """Draws a characters vs. indels, accumulated-positions curve graph and saves it to '../chars-indels'."""
    cum = [0]
    ins = [0]
    dls = [0]
    pos = [0]
    cusum = [0, 0]
    for x in range(len(changelog)):
        if changelog[x][1] == 'insert':
            cum.append(cum[x] + len(changelog[x][3]))
            ins.append(ins[x] + len(changelog[x][3]))
            dls.append(dls[x])
        if changelog[x][1] == 'delete':
            cum.append(cum[x] - (changelog[x][3] - changelog[x][2] + 1))
            ins.append(ins[x])
            dls.append(changelog[x][3] - changelog[x][2] + 1)
        pos.append(changelog[x][2] - x)
        cusum.append(changelog[x][2] - x + cusum[x - 1])
    # plt.plot(np.array(cum))
    plt.ylabel('Cusum')
    plt.xlabel('Indels')
    plt.plot(cusum)
    fig = plt.gcf()
    fig.canvas.set_window_title(name)
    plt.savefig('../cusum/' + name + '.png', bbox_inches='tight')
    plt.clf()


def get_keywords(changelog):
    stemmer = SnowballStemmer('spanish')
    text = reproduce(changelog, 0)
    regex = re.compile('([^\s\w]|_)+')
    alfa = regex.sub('', text)
    stemmed_text = [stemmer.stem(i) for i in word_tokenize(alfa)]
    c = Counter(stemmed_text)
    d = dict(c)
    blacklist = ['tambien', 'sus', 'com', 'cual', 'si', 'son', 'pued', 'dad', 'ya', 'hay', 'esta', 'su', 'o', 'sea',
                 'ha', 'asi', 'lo', 'mas', 'sin', 'a', 'es', 'una', 'de', 'se', 'los', 'la', 'el', 'y', 'en', 'par',
                 'del', 'que', 'no', 'un', 'por', 'las', 'con', 'este', 'al', 'permit', 'form']
    for word in blacklist:
        if word in d:
            d.pop(word)
    import operator
    highest = dict(sorted(d.items(), key=operator.itemgetter(1), reverse=True)[:5])
    return highest.keys()


def code(changelog, n):
    """Given a changelog, return a coded string with all its changes nested."""
    s = ' '
    t = 0   # level would be calculated dynamically
    text = ''
    last_ibi = 0
    if n == 0 or n > len(changelog):
        n = len(changelog)
    for i in range(n):
        print(changelog[i])
        type = changelog[i][1]
        ibi = changelog[i][2]
        if type == 'insert':
            pointer = position(s, int(changelog[i][2]))
            if ibi == last_ibi:
                s = s[:pointer - 1] + changelog[i][3] + s[pointer - 1:]
                print("POINTER =", pointer)
            else:
                s = s[:pointer - 1] + '|' + changelog[i][3] + '|' + s[pointer - 1:]
                print("POINTER =", pointer)
        text = apply_change(text, changelog[i])
        last_ibi = ibi+len(changelog[i][3])
        print(s)
    return s


def position(s, ibi):
    ibi -= 1
    pointer = 0
    for c in s:
        pointer += 1
        if c != '|':
            ibi -= 1
        if ibi == 0:
            return pointer
    return None

save_changelog('54',get_changelog('54.txt'))


# for id in get_info().keys():
#    save_changelog(id,get_changelog(id+".txt"))
save_changelog('52',get_changelog('52'+".txt"))
