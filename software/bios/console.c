#include <endeavour_defs.h>

#include "bios.h"

const char* console_help_msg =
      "\nUART console. Commands:\n"
      "\tW addr val\t\t\t- save 4B to RAM\n"
      "\tR addr\t\t\t\t- load 4B from RAM\n"
      "\tSD addr sector\t\t- load SD card sector to addr\n"
      "\tUART addr size\t\t- receive size(decimal) bytes via UART\n"
      "\tFUART addr size\t   - UART with baud rate 12Mhz\n"
      "\tCRC32 addr size [expected] - calculate crc of data in RAM\n"
      "\tMEMTEST\t\t\t   - rerun memtest\n"
      "\tJ addr\t\t\t\t- run code at addr\n\n";

void uart_console() {
  while (1) {
    bios_printf("> ");
    #define CMD_BUF_SIZE 64
    char cmd[CMD_BUF_SIZE];
    unsigned long addr;
    unsigned val;
    int size, c;
    int cmd_len = bios_gets(cmd, CMD_BUF_SIZE);
    int fast_uart = cmd[0] == 'F';
    switch (cmd[0]) {
      case 'W':
        if (bios_sscanf(cmd, "W %x %x", &addr, &val) == 2) {
          *(volatile unsigned*)addr = val;
          continue;
        }
        break;
      case 'R':
        if (bios_sscanf(cmd, "R %x", &addr) == 1) {
          bios_printf("%8x\n", *(volatile unsigned*)addr);
          continue;
        }
        break;
      case 'S':
        if (bios_sscanf(cmd, "SD %x %x", &addr, &val) == 2) {
          int res = bios_sdread((unsigned*)addr, val, 1);
          if (!res) bios_printf("SD error\n");
          continue;
        }
        break;
      case 'U':
      case 'F':
        if (bios_sscanf(cmd + fast_uart, "UART %x %d", &addr, &size) == 2) {
          if (addr < BIOS_RAM_ADDR || addr + size <= addr) {
            bios_printf("Invalid destination\n");
            uart_flush();
          } else {
            bios_read_uart((char*)addr, size, fast_uart ? UART_BAUD_RATE(12000000) : -1);
          }
          continue;
        }
        break;
      case 'C':
        val = 0;
        c = bios_sscanf(cmd + fast_uart, "CRC32 %x %d %x", &addr, &size, &val);
        if (c == 2 || c == 3) {
          unsigned crc = bios_crc32((char*)addr, size);
          bios_printf("%8x", crc);
          if (val) {
            bios_printf(crc == val ? " OK" : " ERROR");
          }
          bios_putc('\n');
          continue;
        }
        break;
      case 'M':
        memtest();
        continue;
      case 'J':
        if (bios_sscanf(cmd, "J %x", &addr) == 1) {
          asm volatile("fence.i");
          IO_PORT(BOARD_LEDS) = 0x2;
          ((void (*)())addr)();
          continue;
        }
        break;
      case 'h':
      case 'H':
        bios_printf(console_help_msg);
      case '\n': continue;
    }
    bios_printf("Invalid command\n");
    uart_flush();
  }
}