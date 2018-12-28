#! /usr/bin/env nix-shell
/*
#! nix-shell -i node -p nodejs-9_x
*/

const fs = require('fs');

const rows = fs.readFileSync('day3.txt', 'utf8').split('\n').filter(x => !!x).map(line => {
  [id, rest] = line.split(' @ ');
  [coord, size] = rest.split(': ');
  [x, y] = coord.split(',').map(Number);
  [w, h] = size.split('x').map(Number);
  return [id, x, y, w, h];
});

const map = [];
for (let i = 0; i < 1000; i++) {
  for (let j = 0; j < 1000; j++) {
    map[1000 * i + j] = [];
  }
}

rows.forEach(([id, x, y, w, h]) => {
  for (let i = 0; i < w; i++) {
    for (let j = 0; j < h; j++) {
      map[1000 * (x + i) + (y + j)].push(id);
    }
  }
});

const twoOrMore = map.reduce((acc, x) => acc + (x.length >= 2), 0);
console.log('Part 1: ', twoOrMore);

const notOverlapping = rows.find(([id, x, y, w, h]) => {
  for (let i = 0; i < w; i++) {
    for (let j = 0; j < h; j++) {
      if (map[1000 * (x + i) + (y + j)].length > 1) {
        return false;
      }
    }
  }
  return true;
});
console.log('Part 2: ', notOverlapping);
