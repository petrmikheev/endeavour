#!/usr/bin/python3
#coding: utf-8

import sys

fname = sys.argv[1]
offset = int(sys.argv[2])

for line in open(fname, 'r'):
  if line.startswith('\t'):
    prefix = line.split(':')[0]
    v = int(line.split(':')[0].strip()) + offset
    line = '\t%-5d%s' % (v, line[len(prefix):])
  print(line.rstrip())
