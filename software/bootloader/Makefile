
ADDR=40002400
TOOLCHAIN=riscv64-unknown-elf-

.PHONY: all
all: bootloader.bin bootloader_no_read.packed

bootloader.bin: bootloader.elf
	${TOOLCHAIN}objcopy -O binary bootloader.elf bootloader.bin

bootloader.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h
	${TOOLCHAIN}gcc -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -Wl,--section-start=.text=0x${ADDR} -o bootloader.elf asm.S bootloader.c

bootloader_no_read.packed: bootloader_no_read.bin
	echo "UART ${ADDR}" $$(stat -c%s bootloader_no_read.bin) > bootloader_no_read.packed
	cat bootloader_no_read.bin >> bootloader_no_read.packed
	echo "J ${ADDR}" >> bootloader_no_read.packed

bootloader_no_read.bin: bootloader_no_read.elf
	${TOOLCHAIN}objcopy -O binary bootloader_no_read.elf bootloader_no_read.bin

bootloader_no_read.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h
	${TOOLCHAIN}gcc -DSKIP_READ -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -Wl,--section-start=.text=0x${ADDR} -o bootloader_no_read.elf asm.S bootloader.c

endeavour.dtb: endeavour.dts
	dtc endeavour.dts -o endeavour.dtb

.PHONY: clean
clean:
	rm -f *.bin *.elf *.packed endeavour.dtb
