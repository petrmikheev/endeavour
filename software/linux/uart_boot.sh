#!/bin/bash

KERNEL=$1
#INITRD=initramfs.img
INITRD=initrd.img
INITRD_ADDR=87000000

function run_kernel {
    echo "FUART 80400000" $(stat -c%s $KERNEL) " # send kernel" > /dev/ttyUSB1
    sleep 0.5
    ../../scripts/send_file_uart_12mhz.sh $KERNEL
    sleep 0.5
    #echo "FUART $INITRD_ADDR" $(stat -c%s $INITRD) " # send initrd" > /dev/ttyUSB1
    #sleep 0.5
    #../../scripts/send_file_uart_12mhz.sh $INITRD
    #sleep 0.5
    echo "UART 40002400" $(stat -c%s ../bootloader/bootloader_preloaded.bin) " # send bootloader" > /dev/ttyUSB1
    cat  ../bootloader/bootloader_preloaded.bin > /dev/ttyUSB1
    echo "CRC32 80400000" $(stat -c%s $KERNEL) $(crc32 $KERNEL) " # check kernel CRC" > /dev/ttyUSB1
    #echo "CRC32 $INITRD_ADDR" $(stat -c%s $INITRD) $(crc32 $INITRD) > /dev/ttyUSB1
    echo "J 40002400 # jump to bootloader" > /dev/ttyUSB1
}

pushd ../../rtl/board_rev2
make write
popd
(sleep 8 ; run_kernel)&
cat /dev/ttyUSB1
