#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TOOLCHAIN=riscv64-unknown-elf-
CFLAGS="-march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -fno-zero-initialized-in-bss -I${SCRIPT_DIR}/../include"

${TOOLCHAIN}gcc -T ${SCRIPT_DIR}/in_iram.lds $CFLAGS -o $1.elf ${SCRIPT_DIR}/start.S ${@:2}
${TOOLCHAIN}objcopy -O binary $1.elf $1.bin
${TOOLCHAIN}objdump -h $1.elf
${TOOLCHAIN}objdump -d $1.elf > $1.disasm
${SCRIPT_DIR}/pack.sh $1.bin 40002000 > $1.packed
