
ADDR=80400000
TOOLCHAIN=riscv64-unknown-elf-

.PHONY: all
all: usbtest.packed

usbtest.bin: usbtest.elf
	${TOOLCHAIN}objcopy -O binary usbtest.elf usbtest.bin

usbtest.elf: start.S *.h *.c
	${TOOLCHAIN}gcc -T lds -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -I../include -o usbtest.elf start.S *.c

usbtest.packed: usbtest.bin
	echo "UART ${ADDR}" $$(stat -c%s usbtest.bin) > usbtest.packed
	cat usbtest.bin >> usbtest.packed
	echo "J ${ADDR}" >> usbtest.packed

.PHONY: clean
clean:
	rm -f *.bin *.elf *.packed
