import sys
import re

if len(sys.argv) != 3:
    exit(f"{sys.argv[0]} FILENAME LIMIT")

_, filename, limit = sys.argv

with open(filename) as fh:
    for line in fh:
        for _ in range(int(limit)):
            if re.search(r'(.)y\1', line):
                print(line)

