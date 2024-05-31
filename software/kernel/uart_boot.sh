#!/bin/bash

KERNEL=$1
#INITRD=initramfs.img
INITRD=initrd.img
INITRD_ADDR=87000000

function run_kernel {
    echo "FUART 80400000" $(stat -c%s $KERNEL) $(crc32 $KERNEL) > /dev/ttyUSB1
    sleep 0.5
    ../../scripts/send_file_uart_6mhz.sh $KERNEL
    sleep 0.5
    echo "FUART $INITRD_ADDR" $(stat -c%s $INITRD) $(crc32 $INITRD) > /dev/ttyUSB1
    sleep 0.5
    ../../scripts/send_file_uart_6mhz.sh $INITRD
    sleep 0.5
    cat  ../bootloader/bootloader_no_read.packed > /dev/ttyUSB1
}

pushd ../../rtl/board_rev2
make write
popd
(sleep 10 ; run_kernel)&
cat /dev/ttyUSB1
