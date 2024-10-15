
SRC = dhry_1.c dhry_2.c strcmp.S
HDR = dhry.h

dhrystone.packed: dhrystone.bin
	../pack.sh dhrystone.bin 80100000 > dhrystone.packed

dhrystone.bin: $(SRC) $(HDR)
	riscv64-unknown-elf-gcc -T dhrystone.lds -march=rv32im -mabi=ilp32 -nostdlib -ffreestanding -I../include -I. -o dhrystone.elf -O3 -DTIME start.S $(SRC) 2> /dev/null
	riscv64-unknown-elf-objcopy -O binary dhrystone.elf dhrystone.bin
	riscv64-unknown-elf-objdump -h dhrystone.elf

.PHONY runsim:
runsim: dhrystone.bin
	echo J 80100000 > uartcmd
	cd ../../rtl/testbench && make run ARGS="+uart=../../software/dhrystone/uartcmd +ram=../../software/dhrystone/dhrystone.bin +ram_offset=100000"

clean:
	rm -f *.i *.s *.o dhrystone.bin dhrystone.elf dhrystone.packed uartcmd

