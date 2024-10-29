#!/bin/bash

BOOTLOADER=../../software/bootloader/bootloader_preloaded.packed
KERNEL=../../../endeavour-tools/linux_kernel/arch/riscv/boot/Image

make
./testbench.vvp +uart=$BOOTLOADER +ram=$KERNEL +ram_offset=400000 $1
