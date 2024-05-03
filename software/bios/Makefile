sources = start.S main.c util.c sdcard.c

.PHONY: all
all: bios.hex bios_sim.bin

bios.hex: bios.bin ../../scripts/gen_hex.py
	../../scripts/gen_hex.py bios.bin > bios.hex

bios.elf: $(sources) ../include/endeavour_defs.h
	riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -I../include -o bios.elf -Os -Wl,--section-start=.text=0x40000000 $(sources)

bios.bin: bios.elf
	riscv64-unknown-elf-objcopy -O binary bios.elf bios.bin

bios_sim.elf: $(sources) ../include/endeavour_defs.h
	riscv64-unknown-elf-gcc -DSIMULATION -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -I../include -o bios_sim.elf -Os -Wl,--section-start=.text=0x40000000 $(sources)

bios_sim.bin: bios_sim.elf
	riscv64-unknown-elf-objcopy -O binary bios_sim.elf bios_sim.bin

.PHONY: hexdump
hexdump: bios.bin
	hexdump -e '1/4 "%04_ax: %08x\n"' bios.bin

.PHONE: objdump
objdump: bios.elf
	riscv64-unknown-elf-objdump -d bios.elf

.PHONY: clean
clean:
	rm -f *.bin *.elf bios.hex


