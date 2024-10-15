#!/bin/bash

BOOTLOADER=../../software/bootloader/bootloader_no_read.packed
KERNEL=/home/petya/linux/linux-6.9.2/arch/riscv/boot/Image

make
./testbench.vvp +uart=$BOOTLOADER +ram=$KERNEL +ram_offset=400000 $1