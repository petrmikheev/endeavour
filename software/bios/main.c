#include <endeavour_defs.h>

unsigned init_sdcard();  // implemented in sdcard.c

static void wait(volatile int i) {
  while (i > 0) i--;
}

void UART_flush() {
  while (1) {
    wait(16384);
    if (IO_PORT(UART_RX) < 0) {
      IO_PORT(UART_RX) = 0;
      return;
    }
    while (IO_PORT(UART_RX) >= 0);
  }
}

int UART_getc() {
  int x;
  do { x = IO_PORT(UART_RX); } while (x < 0);
  if (x > 0xff) IO_PORT(BOARD_LEDS) |= 0x4;  // third LED means UART error
  return x;
}

void UART_read(char* dst, int size, unsigned expected_crc) {
  unsigned ncrc = 0xffffffff;
  for (int i = 0; i < size; ++i) {
    int x = UART_getc();
    if (x > 0x1ff) {
      bios_printf("Framing error at pos %d\n", i);
      UART_flush();
      return;
    }
    if (x < 0x100) {
      *(dst++) = (char)x;
    } else {
      bios_printf("Parity error at pos %d\n", i);
      x = *(dst++);  // use value from memory to calculate CRC
    }
    for (int j = 0; j < 8; ++j) {
      int b = (x ^ ncrc) & 1;
      ncrc >>= 1;
      x >>= 1;
      if (b) ncrc ^= 0xedb88320;
    }
  }
  if (expected_crc) {
    unsigned crc = ~ncrc;
    if (expected_crc == crc) {
      bios_printf("CRC OK\n");
    } else {
      bios_printf("CRC error %8x != %8x\n", crc, expected_crc);
      UART_flush();
    }
  }
}

void print_cpu_info() {
  bios_printf("CPU: rv32im");
  unsigned isa;
  asm volatile("csrr %0, 0x301" : "=r" (isa));
  isa &= ~0x1100;  // exclude 'i', 'm'
  for (int i = 0; i < 26; ++i) {
    if (isa & 1) bios_putc('a' + i);
    isa = isa >> 1;
  }
  bios_printf(", 1 core, %uMhz\n", CPU_FREQ / 1000000);
}

unsigned test_ram_size() {
  // TODO
  return 0;
}

int main() {
  IO_PORT(BOARD_LEDS) = 0x1;  // first LED on, means that bootloader has started
  IO_PORT(UART_CFG) = UART_BAUD_RATE(115200) | UART_PARITY_EVEN | UART_CSTOPB;
  while (IO_PORT(UART_RX) >= 0);  // clear UART input buffer
  IO_PORT(UART_RX) = 0;  // clear UART framing error flag

  RAM_SIZE = test_ram_size();
  // TODO initialize video in text mode

  bios_printf(
      "\n\n"
      "\t\t\tEndeavour\n"
      "\t\t\t=========\n\n"
  );
  print_cpu_info();
  bios_printf("RAM: %uMB\n", RAM_SIZE >> 20);
  SDCARD_SECTOR_COUNT = init_sdcard();

  if ((IO_PORT(BOARD_KEYS) & 1) || SDCARD_SECTOR_COUNT < 2) {
    // don't boot from sdcard
  } else if (bios_sdread((unsigned*)BIOS_RAM_ADDR, 0, 2) != 2) {
    bios_printf("Failed to read SD boot sector\n");
  } else if (*(unsigned*)(BIOS_RAM_ADDR + 0x3fc) != 0x405a0000) {
    bios_printf("SD boot sector has no boot signature\n");
  } else {
    bios_printf("Boot from SD card\n");
    IO_PORT(BOARD_LEDS) = 0x2;
    ((void (*)())BIOS_RAM_ADDR)();
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
          int res = bios_sdread((unsigned*)addr, val, 1);
          if (!res) bios_printf("SD error\n");
          continue;
        }
        break;
      case 'U':
        val = 0;
        c = bios_sscanf(cmd, "UART %x %d %x", &addr, &size, &val);
        if (c == 2 || c == 3) {
          if (addr < BIOS_RAM_ADDR || addr + size <= addr) {
            bios_printf("Invalid destination\n");
            UART_flush();
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
    UART_flush();
  }
}
