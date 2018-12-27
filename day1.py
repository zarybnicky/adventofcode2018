#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import itertools

with open('day1.txt') as f:
    data = [int(x) for x in f.read().split('\n') if x]

print('Part 1:', sum(data))

current = 0
seen = set()
for x in itertools.cycle(data):
    current += x
    if current in seen:
        break
    seen.add(current)

print('Part 2:', current)
