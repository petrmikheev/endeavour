#!/usr/bin/python3
#coding: utf-8

import struct, sys

bytes_per_word = 8

bytes = open(sys.argv[1], 'rb').read()
bytes += b'\0' * ((bytes_per_word - len(bytes) % bytes_per_word) % bytes_per_word)

assert len(bytes) % bytes_per_word == 0
count = len(bytes) // bytes_per_word
for c in range(count):
    v = struct.unpack('<Q', bytes[c*bytes_per_word:c*bytes_per_word+bytes_per_word])[0]
    data = ('%02X%04X00%0'+str(bytes_per_word*2)+'X') % (bytes_per_word, c, v)
    data += '%02X' % ((256 - sum([int(data[i:i+2],16) for i in range(0,len(data),2)])) % 256)
    print(':'+data)
print(':00000001FF')

