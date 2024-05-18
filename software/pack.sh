#!/bin/bash

echo "UART ${2:-40002000}" $(stat -c%s $1) $(crc32 $1)
cat $1
echo "J ${2:-40002000}"
