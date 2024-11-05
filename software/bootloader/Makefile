TOOLCHAIN=riscv64-unknown-elf-
CFLAGS=-march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -fno-zero-initialized-in-bss -I../include -Os

.PHONY: all
all: bootloader.packed bootloader_preloaded.bin

bootloader.packed: bootloader.bin
	../util/pack.sh bootloader.bin 40002400 > bootloader.packed

bootloader.bin: bootloader.elf
	${TOOLCHAIN}objcopy -O binary bootloader.elf bootloader.bin

bootloader.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h ../include/endeavour_ext2.h ../util/ext2.c
	${TOOLCHAIN}gcc -T bootloader.lds ${CFLAGS} -o bootloader.elf asm.S bootloader.c ../util/ext2.c

bootloader_preloaded.bin: bootloader_preloaded.elf
	${TOOLCHAIN}objcopy -O binary bootloader_preloaded.elf bootloader_preloaded.bin

bootloader_preloaded.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h
	${TOOLCHAIN}gcc -DRUN_PRELOADED_KERNEL -T bootloader.lds ${CFLAGS} -o bootloader_preloaded.elf asm.S bootloader.c

endeavour.dtb: endeavour.dts
	dtc endeavour.dts -o endeavour.dtb

.PHONY: clean
clean:
	rm -f *.bin *.elf *.packed endeavour.dtb
