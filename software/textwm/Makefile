TOOLCHAIN=../../../endeavour-tools/rv32imac-linux-toolchain/bin/riscv32-unknown-linux-gnu-

textwm: textwm.c textwm.h utf8.c utf8.h tty.c tty.h input.c input.h
	${TOOLCHAIN}gcc -s -o textwm textwm.c utf8.c tty.c input.c

.PHONY: clean
clean:
	rm -f textwm
