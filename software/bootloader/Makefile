TOOLCHAIN=riscv64-unknown-elf-

.PHONY: all
all: bootloader.bin bootloader_preloaded.bin

bootloader.bin: bootloader.elf
	${TOOLCHAIN}objcopy -O binary bootloader.elf bootloader.bin

bootloader.elf: asm.S bootloader.c ext2.c endeavour.dtb ../include/endeavour_defs.h ext2.h
	${TOOLCHAIN}gcc -T bootloader.lds -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -o bootloader.elf asm.S bootloader.c ext2.c

bootloader_preloaded.bin: bootloader_preloaded.elf
	${TOOLCHAIN}objcopy -O binary bootloader_preloaded.elf bootloader_preloaded.bin

bootloader_preloaded.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h
	${TOOLCHAIN}gcc -DRUN_PRELOADED_KERNEL -T bootloader.lds -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -o bootloader_preloaded.elf asm.S bootloader.c

endeavour.dtb: endeavour.dts
	dtc endeavour.dts -o endeavour.dtb

.PHONY: clean
clean:
	rm -f *.bin *.elf endeavour.dtb
