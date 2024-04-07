#!/bin/bash

stty -F /dev/ttyUSB1 115200 -icrnl -ixon -ixoff -opost -isig -icanon -echo cstopb -crtscts parenb
cat /dev/ttyUSB1
