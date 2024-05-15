sources = start.S main.c util.c sdcard.c charmap.S

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

ter-u16.bdf:
	wget http://downloads.sourceforge.net/project/terminus-font/terminus-font-4.49/terminus-font-4.49.1.tar.gz
	tar xvzf terminus-font-4.49.1.tar.gz
	ln -sf terminus-font-4.49.1/ter-u16n.bdf ter-u16.bdf

charmap.S: ter-u16.bdf
	python3 gen_charmap.py ter-u16.bdf > charmap.S

.PHONY: clean
clean:
	rm -f *.bin *.elf bios.hex terminus-font-* ter-u16.bdf charmap.S


