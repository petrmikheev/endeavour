#!/bin/bash

riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -Iinclude -o $1.elf -Os -Wl,--section-start=.text=${2:-0x40002000} start.S $1.c
riscv64-unknown-elf-objcopy -O binary $1.elf $1.bin
riscv64-unknown-elf-objdump -h $1.elf
rm $1.elf
