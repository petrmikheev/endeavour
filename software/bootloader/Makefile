TOOLCHAIN=riscv64-unknown-elf-
CFLAGS=-march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding -fno-zero-initialized-in-bss -I../include -Os

.PHONY: all
all: bootloader.packed bootloader_preloaded.bin

bootloader.packed: bootloader.bin
	../util/pack.sh bootloader.bin 40002400 > bootloader.packed

bootloader.bin: bootloader.elf
	${TOOLCHAIN}objcopy -O binary bootloader.elf bootsector_and_loader.bin
	dd if=bootsector_and_loader.bin of=bootloader.bin skip=2 count=12

bootloader.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h ../include/endeavour_ext2.h ../util/ext2.c
	${TOOLCHAIN}gcc -T bootloader.lds ${CFLAGS} -o bootloader.elf asm.S bootloader.c ../util/ext2.c

bootloader_preloaded.bin: bootloader_preloaded.elf
	${TOOLCHAIN}objcopy -O binary bootloader_preloaded.elf bootsector_and_loader_preloaded.bin
	dd if=bootsector_and_loader_preloaded.bin of=bootloader_preloaded.bin skip=2 count=12

bootloader_preloaded.elf: asm.S bootloader.c endeavour.dtb ../include/endeavour_defs.h
	${TOOLCHAIN}gcc -DRUN_PRELOADED_KERNEL -T bootloader.lds ${CFLAGS} -o bootloader_preloaded.elf asm.S bootloader.c

endeavour.dtb: endeavour.dts
	dtc endeavour.dts -o endeavour.dtb

.PHONY: write_to_mmcblk0
write_to_mmcblk0:
	cp bootsector_and_loader.bin tmp.bin
	dd if=/dev/mmcblk0 of=tmp.bin bs=1 conv=notrunc skip=$((0x1b8)) seek=$((0x1b8)) count=$((0x200-0x1b8)) # copy existing partition table
	sudo dd if=tmp.bin of=/dev/mmcblk0

.PHONY: clean
clean:
	rm -f *.bin *.elf *.packed endeavour.dtb tmp.bin
