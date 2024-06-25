#!/bin/sh

stty raw
/mnt/textwm < /dev/ttyS0 &
sleep 0.5
cat /mnt/textwm.cfg > /dev/textwmcfg
export HOME=/root
export PS1="\u:\e[34m\w\e[m$ "
setsid sh -c 'exec sh </dev/ttyp0 >/dev/ttyp0 2>&1'
