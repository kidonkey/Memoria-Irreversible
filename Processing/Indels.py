import json
from pprint import pprint
from itertools import islice


def parse_mlti(mts):
    for i in range(len(mts)):
        if mts[i]['ty'] == 'is':
            changelog.append((timestamp, 'insertion', mts[i]['ibi'], mts[i]['s']))
            print(mts[i]['ibi'], mts[i]['s'])
        elif mts[i]['ty'] == 'ds':
            changelog.append((timestamp, 'deletion', mts[i]['si'], mts[i]['ei']))
            print(mts[i]['si'], mts[i]['ei'])
        elif mts[i]['ty'] == 'mlti':
            parse_mlti(mts[i]['mts'])
        else:
            continue


changelog = []
with open("../data/54.txt", 'rt', encoding="utf8") as f:
    for l in islice(f, 1):
        # print(l)
        data = json.loads(l)
        # print(json.dumps(data,indent=2, separators=(',', ': ')))
        for i in range(0, 1000):  # timestamp
            timestamp = data['changelog'][i][1]
            print('timestamp:', timestamp)
            if data['changelog'][i][0]['ty'] == 'is':
                pos = data['changelog'][i][0]['ibi']
                s = data['changelog'][i][0]['s']
                print(pos, s)
                changelog.append((timestamp, 'insertion', pos, s))
            if data['changelog'][i][0]['ty'] == 'ds':
                start = data['changelog'][i][0]['si']
                end = data['changelog'][i][0]['ei']
                print(start, end)
                changelog.append((timestamp, 'deletion', start, end))
            if data['changelog'][i][0]['ty'] == 'mlti':
                parse_mlti(data['changelog'][i][0]['mts'])
pprint(changelog)
log = []
ibis = 0
change = ''
for i in range(len(changelog) - 1):
    if changelog[i][1] == changelog[i + 1][1] == 'insertion':
        change += changelog[i + 1][3]
    elif changelog[i][1] != changelog[i + 1][1] and changelog[i][1] == 'insertion':
        log.append((changelog[i][0], changelog[i][1], changelog[i][2], change+changelog[i][3]))
        change = ''
#pprint(log)
text = ''
for i in range(len(changelog)):
    type = changelog[i][1]
    if type == 'insertion':
        ibi = changelog[i][2]
        text = text[:ibi-1] + changelog[i][3] + text[ibi-1:]
    if type == 'deletion':
        text = text[:changelog[i][2]-1]+text[changelog[i][3]:]
    #print(changelog[i])
print(text)