#!/bin/bash

sudo chmod a+rw /dev/ttyUSB1
stty -F /dev/ttyUSB1 115200 -icrnl -ixon -ixoff -opost -isig -icanon -echo cstopb -crtscts parenb
