sources = start.S main.c util.c sdcard.c console.c charmap.S
sources_minimal = start.S main_minimal.c util.c console.c

TOOLCHAIN=riscv64-unknown-elf-
OPTIONS=-march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -T bios.lds
OPTIONS_MINIMAL=-march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -I../include -Os -T bios.lds -DNO_DISPLAY -DNO_SDCARD

.PHONY: all
all: bios.hex bios_minimal.hex bios_sim.bin

bios.hex: bios.bin gen_hex.py
	./gen_hex.py bios.bin 8 > bios.hex

bios_minimal.hex: bios_minimal.bin gen_hex.py
	./gen_hex.py bios_minimal.bin 4 > bios_minimal.hex

bios.elf: $(sources) ../include/endeavour_defs.h
	${TOOLCHAIN}gcc ${OPTIONS} -o bios.elf $(sources)

bios.bin: bios.elf
	${TOOLCHAIN}objcopy -O binary bios.elf bios.bin

bios_sim.elf: $(sources) ../include/endeavour_defs.h
	${TOOLCHAIN}gcc ${OPTIONS} -DSIMULATION -o bios_sim.elf $(sources)

bios_sim.bin: bios_sim.elf
	${TOOLCHAIN}objcopy -O binary bios_sim.elf bios_sim.bin

bios_minimal.elf: $(sources_minimal) ../include/endeavour_defs.h
	${TOOLCHAIN}gcc ${OPTIONS_MINIMAL} -o bios_minimal.elf $(sources_minimal)

bios_minimal.bin: bios_minimal.elf
	${TOOLCHAIN}objcopy -O binary bios_minimal.elf bios_minimal.bin

.PHONY: hexdump
hexdump: bios.bin
	hexdump -e '1/4 "%04_ax: %08x\n"' bios.bin

.PHONE: objdump
objdump: bios.elf
	${TOOLCHAIN}objdump -d bios.elf

.PHONE: objdump_sim
objdump_sim: bios_sim.elf
	${TOOLCHAIN}objdump -d bios_sim.elf

ter-u16.bdf:
	wget http://downloads.sourceforge.net/project/terminus-font/terminus-font-4.49/terminus-font-4.49.1.tar.gz
	tar xvzf terminus-font-4.49.1.tar.gz
	ln -sf terminus-font-4.49.1/ter-u16n.bdf ter-u16.bdf

charmap.S: ter-u16.bdf
	python3 gen_charmap.py ter-u16.bdf > charmap.S

.PHONY: clean
clean:
	rm -rf *.bin *.elf bios.hex terminus-font-* ter-u16.bdf charmap.S


