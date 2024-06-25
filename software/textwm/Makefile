TOOLCHAIN=../../../endeavour-tools/rv32imac-linux-toolchain/bin/riscv32-unknown-linux-gnu-

textwm: textwm.c
	${TOOLCHAIN}gcc -s -o textwm textwm.c

.PHONY: clean
clean:
	rm -f textwm
