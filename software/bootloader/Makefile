sources = start.S bootloader.c

bootloader.hex: bootloader.bin ../../scripts/gen_hex.py
	../../scripts/gen_hex.py bootloader.bin > bootloader.hex

bootloader.elf: $(sources)
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding -I../include -o bootloader.elf -O3 -Wl,--section-start=.text=0x40000000 $(sources) -fno-inline-small-functions

bootloader.bin: bootloader.elf
	riscv64-unknown-elf-objcopy -O binary bootloader.elf bootloader.bin

.PHONY: hexdump
hexdump: bootloader.bin
	hexdump -e '1/4 "%04_ax: %08x\n"' bootloader.bin

.PHONE: objdump
objdump: bootloader.elf
	riscv64-unknown-elf-objdump -d bootloader.elf

.PHONY: clean
clean:
	rm -f bootloader.bin bootloader.elf bootloader.hex


