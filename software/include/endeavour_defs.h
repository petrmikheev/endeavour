#ifndef ENDEAVOUR_DEFS_H
#define ENDEAVOUR_DEFS_H

#define BIOS_ROM_ADDR 0x40000000
#define BIOS_ROM_SIZE 0x2000

#define BIOS_RAM_ADDR 0x40002000
#define BIOS_RAM_SIZE 0x2000

#define BIOS_STACK_ADDR 0x40003FF8
#define SDCARD_SECTOR_COUNT *(unsigned*)0x40003FFC
#define SDCARD_SECTOR_SIZE 512

#define RAM_ADDR 0x80000000
#define RAM_SIZE *(unsigned*)0x40003FF8

// IO registers

#define UART_RX 0x100
#define UART_TX 0x104
#define UART_CFG 0x108

#define AUDIO_CFG 0x200
// write - add to stream, read - remaining buf size
#define AUDIO_STREAM 0x204

#define BOARD_LEDS     0x800
#define BOARD_KEYS     0x804
#define BOARD_CPU_FREQ 0x808

#define SDCARD_CMD 0x900
#define SDCARD_DATA 0x904
#define SDCARD_FIFO0 0x908
#define SDCARD_FIFO1 0x90C
#define SDCARD_PHY 0x910
#define SDCARD_FIFO0_LE 0x918  // FIFO0 with big-endian -> little-endian conversion
#define SDCARD_FIFO1_LE 0x91C  // FIFO1 with big-endian -> little-endian conversion

#define IO_PORT(X) (*(volatile int*)(X))

// UART_CFG flags
#define UART_BAUD_RATE(X) (48000000 / (X) - 1)
#define UART_PARITY_NONE  0
#define UART_PARITY_EVEN  (1<<16)
#define UART_PARITY_ODD   (3<<16)
#define UART_CSTOPB       (4<<16)

// UART_RX flags
#define UART_PARITY_ERROR  0x100
#define UART_FRAMING_ERROR 0x200

// AUDIO_CFG flags
#define AUDIO_SAMPLE_RATE(X) (48000000 / (X) - 1)
#define AUDIO_VOLUME(X) (((unsigned)(X)&15) << 16)
#define AUDIO_MAX_VOLUME 15
#define AUDIO_FLUSH 0x80000000

// AUDIO_CMD flags
#define AUDIO_CLEAR_STREAM0 1
#define AUDIO_CLEAR_STREAM1 2

// builtin functions

#define bios_reset   ((void (*)())                                   (BIOS_ROM_ADDR + 0x0))
#define bios_putc    ((void (*)(char))                               (BIOS_ROM_ADDR + 0x4))
#define bios_printf  ((void (*)(const char*, ...))                   (BIOS_ROM_ADDR + 0x8))
#define bios_sscanf  ((int  (*)(const char*, ...))                   (BIOS_ROM_ADDR + 0xC))
#define bios_sdread  ((int  (*)(unsigned*, unsigned, unsigned))      (BIOS_ROM_ADDR + 0x10))
#define bios_sdwrite ((int  (*)(const unsigned*, unsigned, unsigned))(BIOS_ROM_ADDR + 0x14))

#endif  // ENDEAVOUR_DEFS_H

