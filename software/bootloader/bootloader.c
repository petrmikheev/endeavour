#include <endeavour_defs.h>

/*void halt() {
  IO_PORT(BOARD_LEDS) = 0x0;
  bios_printf("System halted\n\n");
  while (1) asm volatile("wfi");
}*/

static void wait(volatile int i) {
  while (i > 0) i--;
}

char UART_getc() {
  int x;
  do { x = IO_PORT(UART_RX); } while (x < 0);
  if (x > 0xff) IO_PORT(BOARD_LEDS) |= 0x4;  // third LED means UART framing error
  return (char)x;
}

void UART_read(char* dst, int size, unsigned expected_crc) {
  unsigned ncrc = 0xffffffff;
  for (int i = 0; i < size; ++i) {
    int x;
    do { x = IO_PORT(UART_RX); } while (x < 0);
    if (x > 0xff) {
      IO_PORT(BOARD_LEDS) |= 0x4;
      bios_printf("Framing error at pos %d\n", i);
      while (1) {
        wait(1000);
        if (IO_PORT(UART_RX) < 0) {
          IO_PORT(UART_RX) = 0;
          return;
        }
        while (IO_PORT(UART_RX) >= 0);
      }
    }
    *(dst++) = (char)x;
    for (int j = 0; j < 8; ++j) {
      int b = (x ^ ncrc) & 1;
      ncrc >>= 1;
      x >>= 1;
      if (b) ncrc ^= 0xedb88320;
    }
  }
  unsigned crc = ~ncrc;
  if (expected_crc && expected_crc != crc) {
    bios_printf("CRC error %8x != %8x\n", crc, expected_crc);
  }
}

int main() {
  IO_PORT(BOARD_LEDS) = 0x1;  // first LED on, means that bootloader has started
  IO_PORT(UART_DIVISOR) = CPU_FREQ / 115200 - 1;  // set UART baud rate to 115200
  while (IO_PORT(UART_RX) >= 0);  // clear UART input buffer
  IO_PORT(UART_RX) = 0;  // clear error flag

  bios_printf("Endeavour\n");

  if (!(IO_PORT(BOARD_KEYS) & 1)) {
    // TODO read first 1KB from sdcard
    bios_printf("Boot from sdcard: not implemented\n");
  }

  bios_printf(
    "\nUART console. Commands:\n"
    "\tW addr val\t\t\t- save 4B to RAM\n"
    "\tR addr\t\t\t\t- load 4B from RAM\n"
    "\tSD addr sector\t\t- load sector from sdcard to addr\n"
    "\tUART addr size crc32  - receive size(decimal) bytes via UART\n"
    "\tJ addr\t\t\t\t- run code at addr\n\n"
  );

  while (1) {
    bios_printf("> ");
    #define CMD_BUF_SIZE 40
    char cmd[CMD_BUF_SIZE];
    int cmd_len = 0;
    char c;
    long addr;
    unsigned val;
    int size;
    do {
      c = UART_getc();
      bios_putc(c);
      cmd[cmd_len++] = c;
    } while (cmd_len < CMD_BUF_SIZE && c != '\n');
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
          bios_printf("Not implemented\n");
          continue;
        }
        break;
      case 'U':
        val = 0;
        c = bios_sscanf(cmd, "UART %x %d %x", &addr, &size, &val);
        if (c == 2 || c == 3) {
          if (addr < INTERNAL_RAM_ADDR || addr + size <= addr) {
            bios_printf("Invalid destination\n");
          } else {
            UART_read((char*)addr, size, val);
          }
          continue;
        }
        break;
      case 'J':
        if (bios_sscanf(cmd, "J %x", &addr) == 1) {
          IO_PORT(BOARD_LEDS) = 0x2;
          ((void (*)())addr)();
          continue;
        }
        break;
    }
    bios_printf("Invalid command\n");
  }
}
