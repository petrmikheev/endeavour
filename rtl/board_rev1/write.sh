#!/bin/bash

sudo rmmod ftdi_sio
sudo ../../mbftdi/mbftdi EndeavourSoc.svf
sudo modprobe ftdi_sio
sleep 1
sudo chmod a+rw /dev/ttyUSB1
