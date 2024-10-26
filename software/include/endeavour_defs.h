#ifndef ENDEAVOUR_DEFS_H
#define ENDEAVOUR_DEFS_H

#define BIOS_ROM_ADDR 0x40000000ul
#define BIOS_ROM_SIZE 0x2000

#define BIOS_RAM_ADDR 0x40002000ul
#define BIOS_RAM_SIZE 0x2000

#define BIOS_CHARMAP_ADDR (*(unsigned long*)(BIOS_ROM_ADDR + 0x18))

#define BIOS_STACK_ADDR 0x40003FE8

#define SDCARD_RCA *(unsigned*)0x40003FE8
#define SDCARD_SECTOR_COUNT *(unsigned*)0x40003FFC
#define SDCARD_SECTOR_SIZE 512

#define RAM_ADDR 0x80000000ul
#define RAM_SIZE *(unsigned*)0x40003FF8

#define BIOS_TEXT_BUFFER_ADDR RAM_ADDR
#define VIDEO_TEXT_BUFFER_SIZE 0x10000  // 64KB
#define BIOS_CURSOR_POS *(unsigned long*)0x40003FF4
#define BIOS_SCREEN_END_POS *(unsigned long*)0x40003FF0
#define BIOS_TEXT_STYLE *(char*)0x40003FEC
#define BIOS_DEFAULT_TEXT_STYLE 0x0F

// IO registers

// write to RX clears framing error flag
#define UART_RX 0x10000  // negative value - buffer empty
#define UART_TX 0x10004  // negative value - buffer full
#define UART_CFG 0x10008

#define AUDIO_CFG 0x20000
#define AUDIO_STREAM 0x20004  // write - add to stream, read - remaining buf size

#define SDCARD_CMD 0x30000
#define SDCARD_DATA 0x30004
#define SDCARD_FIFO0 0x30008
#define SDCARD_FIFO1 0x3000C
#define SDCARD_PHY 0x30010
#define SDCARD_FIFO0_LE 0x30018  // FIFO0 with big-endian -> little-endian conversion
#define SDCARD_FIFO1_LE 0x3001C  // FIFO1 with big-endian -> little-endian conversion

#define USB_OHCI_REGS 0x40000
#define USB_OHCI_DMA  0x41000
#define USB_OHCI_DMA_SIZE 0x1000

#define BOARD_LEDS     0x80000
#define BOARD_KEYS     0x80004
#define BOARD_CPU_FREQ 0x80008
#define BOARD_RAM_FREQ 0x8000C
#define BOARD_TIMECMP  0x80010
#define BOARD_TIMECMPH 0x80014

#define VIDEO_CFG           0x90000
#define VIDEO_TEXT_ADDR     0x90004
#define VIDEO_GRAPHIC_ADDR  0x90008
#define VIDEO_REG_INDEX     0x9000C
#define VIDEO_REG_VALUE     0x90010  // write-only

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

// VIDEO_CFG flags
#define VIDEO_640x480     1
#define VIDEO_1024x768    2
#define VIDEO_1280x720    3
#define VIDEO_TEXT_ON     4
#define VIDEO_GRAPHIC_ON  8
#define VIDEO_FONT_HEIGHT(X) ((((X)-1)&15) << 4) // allowed range [6, 16]
#define VIDEO_FONT_WIDTH(X) ((((X)-1)&7) << 8)   // allowed range [6, 8]
#define VIDEO_RGB565      0
#define VIDEO_RGAB5515    0x800

// VIDEO_REG_INDEX
#define VIDEO_COLORMAP_BG(X) (X)         // Background color RGBA (8, 8, 8, 7); bits 7 unused; X in range [0, 15]
#define VIDEO_COLORMAP_FG(X) (16 + (X))  // Foreground color RGBA (8, 8, 8, 7); bits 7 enables alternative font (char codes 256-511); X in range [0, 15];
#define VIDEO_CHARMAP(CHAR, WORD) ((CHAR) << 2 | (WORD))  // CHAR can be in range [8, 511], WORD in range [0, 3]

// COLORMAP values
#define VIDEO_TEXT_COLOR(R, G, B) ((R)<<24 | (G)<<16 | (B)<<8)
#define VIDEO_TEXT_ALPHA(A) (A)     // 0 - 64
#define VIDEO_ALTERNATIVE_FONT 128  // only in VIDEO_COLORMAP_FG(X)

// builtin functions

#define bios_reset   ((void (*)())                                   (BIOS_ROM_ADDR + 0x0))
#define bios_putc    ((void (*)(char))                               (BIOS_ROM_ADDR + 0x4))
#define bios_printf  ((void (*)(const char* /*fmt*/, ...))           (BIOS_ROM_ADDR + 0x8))
#define bios_sscanf  ((int  (*)(const char* /*fmt*/, ...))           (BIOS_ROM_ADDR + 0xC))
// bios_sdread(dst, sector, sector_count) -> sector_count
#define bios_sdread  ((int  (*)(void*, unsigned, unsigned))          (BIOS_ROM_ADDR + 0x10))
// bios_sdwrite(src, sector, sector_count) -> sector_count
#define bios_sdwrite ((int  (*)(const void*, unsigned, unsigned))    (BIOS_ROM_ADDR + 0x14))
// 0x18 used for BIOS_CHARMAP_ADDR
#define bios_gets    ((int (*)(char*, int /*max_size*/)) /*-> size*/ (BIOS_ROM_ADDR + 0x1C))
// bios_read_uart(dst, size, uart_divisor_override /* -1 - don't override */) -> ok
#define bios_read_uart    ((int (*)(char*, int, int))                (BIOS_ROM_ADDR + 0x20))
#define bios_crc32   ((unsigned (*)(const void*, int))               (BIOS_ROM_ADDR + 0x24))
#define bios_wait_reset   ((void (*)())                              (BIOS_ROM_ADDR + 0x28))

#endif  // ENDEAVOUR_DEFS_H

