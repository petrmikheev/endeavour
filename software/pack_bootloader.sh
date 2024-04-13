#!/bin/bash

truncate -s 1020 $1
echo -n -e '\x00\x00\x5a\x40' >> $1
