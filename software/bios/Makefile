sources = start.S main.c util.c sdcard.c charmap.S

TOOLCHAIN=riscv64-unknown-elf-
OPTIONS=-march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -Wl,--section-start=.text=0x40000000

.PHONY: all
all: bios.hex bios_sim.bin

bios.hex: bios.bin ../../scripts/gen_hex.py
	../../scripts/gen_hex.py bios.bin > bios.hex

bios.elf: $(sources) ../include/endeavour_defs.h
	${TOOLCHAIN}gcc ${OPTIONS} -o bios.elf $(sources)

bios.bin: bios.elf
	${TOOLCHAIN}objcopy -O binary bios.elf bios.bin

bios_sim.elf: $(sources) ../include/endeavour_defs.h
	${TOOLCHAIN}gcc ${OPTIONS} -DSIMULATION -o bios_sim.elf $(sources)

bios_sim.bin: bios_sim.elf
	${TOOLCHAIN}objcopy -O binary bios_sim.elf bios_sim.bin

.PHONY: hexdump
hexdump: bios.bin
	hexdump -e '1/4 "%04_ax: %08x\n"' bios.bin

.PHONE: objdump
objdump: bios.elf
	${TOOLCHAIN}objdump -d bios.elf

ter-u16.bdf:
	wget http://downloads.sourceforge.net/project/terminus-font/terminus-font-4.49/terminus-font-4.49.1.tar.gz
	tar xvzf terminus-font-4.49.1.tar.gz
	ln -sf terminus-font-4.49.1/ter-u16n.bdf ter-u16.bdf

charmap.S: ter-u16.bdf
	python3 gen_charmap.py ter-u16.bdf > charmap.S

.PHONY: clean
clean:
	rm -f *.bin *.elf bios.hex terminus-font-* ter-u16.bdf charmap.S


