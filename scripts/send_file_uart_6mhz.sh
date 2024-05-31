#!/bin/bash

PORT=/dev/ttyUSB1

setserial $PORT spd_cust
setserial $PORT divisor 10
stty -F $PORT 38400 2> /dev/null
cat $1 > $PORT
stty -F $PORT 115200 2> /dev/null
