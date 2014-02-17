from os import walk
from os.path import getmtime, join as path_join
from sys import argv
from time import strftime, gmtime
from collections import defaultdict

days = defaultdict(lambda: 0)
for root, dirs, files in walk(argv[1]):
    for fil in files:
        try:
            mtime = int(fil.split('.', 1)[0])
        except:
            continue
        days[mtime / 86400] += 1
for day in sorted(days.keys()):
    print '%s, %d' % (strftime('%Y-%m-%d', gmtime(day * 86400)), days[day])
