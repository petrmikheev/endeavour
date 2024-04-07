#ifndef ENDEAVOUR_DEFS_H
#define ENDEAVOUR_DEFS_H

#define CPU_FREQ 96000000

#define BIOS_ROM_ADDR 0x40000000
#define BIOS_ROM_SIZE 0x1000

#define INTERNAL_RAM_ADDR 0x40001000
#define INTERNAL_RAM_SIZE 0x3000

#define EXTERNAL_RAM_ADDR 0x80000000
#define EXTERNAL_RAM_SIZE 0x08000000

// IO registers

#define UART_RX 0x100
#define UART_TX 0x104
#define UART_DIVISOR 0x108

#define SDCARD_CMD 0x200
#define SDCARD_ARG 0x204
#define SDCARD_FIFO0 0x208
#define SDCARD_FIFO1 0x20C
#define SDCARD_PHY 0x210

#define BOARD_LEDS 0x300
#define BOARD_KEYS 0x304

#define IO_PORT(X) (*(volatile int*)(X))

#define bios_reset  ((void (*)())                (BIOS_ROM_ADDR + 0x0))
#define bios_putc   ((void (*)(char))            (BIOS_ROM_ADDR + 0x4))
#define bios_printf ((void (*)(const char*, ...))(BIOS_ROM_ADDR + 0x8))
#define bios_sscanf ((int  (*)(const char*, ...))(BIOS_ROM_ADDR + 0xC))

#endif  // ENDEAVOUR_DEFS_H

