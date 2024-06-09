#include <endeavour_defs.h>

// implemented in util.c
void init_text_mode();
void uart_flush();

// implemented in sdcard.c
unsigned init_sdcard();

void print_cpu_info() {
  bios_printf("CPU: rv32im");
  unsigned isa;
  asm volatile("csrr %0, misa" : "=r" (isa));
  isa &= ~0x1100;  // exclude 'i', 'm'
  for (int i = 0; i < 26; ++i) {
    if (isa & 1) bios_putc('a' + i);
    isa = isa >> 1;
  }
  bios_printf(", 1 core, %uMhz\n", IO_PORT(BOARD_CPU_FREQ) / 1000000);
}

int memtest() {
  bios_printf("RAM: %uMB\tmemtest", RAM_SIZE >> 20);
  char* ram = (char*)RAM_ADDR;
#ifndef SIMULATION
  const int batch_size = RAM_SIZE >> 4;
  const int base_step = 4;
#else
  const int batch_size = RAM_SIZE >> 13;
  const int base_step = 256;
#endif
  int i = 8192, j = 8192;  // skip first 32KB (can be currently shown on the display)
  for (int b = 0; b < 4; ++b, j -= batch_size) {
    const int step = base_step + (b & 1);
    for (; j < batch_size; j += step, i += step) {
      char* ptr = ram + (i << 2);
      *(int*)ptr = i | (i << 25);  // test 4 byte write
      *(ptr + 1) ^= 0xff;  // test 1 byte write
    }
    bios_putc('.');
  }
  int ok = 1;
  i = 8192, j = 8192;
  for (int b = 0; b < 4; ++b, j -= batch_size) {
    const int step = base_step + (b & 1);
    for (; j < batch_size; j += step, i += step) {
      char* ptr = ram + (i << 2);
      unsigned expected = (i | (i << 25)) ^ 0xff00;
      ok = ok && (*(ptr + 3) == (expected >> 24));  // test 1 byte read
      ok = ok && (*(int*)ptr == expected);  // test 4 byte read
    }
    bios_putc('.');
  }
  bios_printf(ok ? " OK\n" : " FAILED\n");
  return ok;
}

int main() {
  IO_PORT(BOARD_LEDS) = 0x1;  // first LED on, means that bios has started
#ifndef SIMULATION
  IO_PORT(UART_CFG) = UART_BAUD_RATE(115200) | UART_PARITY_EVEN | UART_CSTOPB;
#else
  // Increase UART speed in simulation
  IO_PORT(UART_CFG) = UART_BAUD_RATE(16000000) | UART_PARITY_EVEN | UART_CSTOPB;
#endif
  while (IO_PORT(UART_RX) >= 0);  // clear UART input buffer
  IO_PORT(UART_RX) = 0;  // clear UART framing error flag

  RAM_SIZE = 128 * 1024 * 1024;

  init_text_mode();

  bios_printf(
      "\n\n"
      "\t\t\tEndeavour\n"
      "\t\t\t=========\n\n"
  );
  print_cpu_info();
#ifndef SIMULATION
  int memtest_ok = memtest();
#else
  int memtest_ok = 1;
#endif
  SDCARD_SECTOR_COUNT = init_sdcard();

  if ((IO_PORT(BOARD_KEYS) & 2) || SDCARD_SECTOR_COUNT < 2) {
    // don't boot from sdcard
  } else if (bios_sdread((unsigned*)BIOS_RAM_ADDR, 0, 2) != 2) {
    bios_printf("Failed to read SD boot sector\n");
  } else if (*(unsigned*)(BIOS_RAM_ADDR + 0x3fc) != 0x405a0000) {
    bios_printf("SD boot sector has no boot signature\n");
  } else if (memtest_ok) {
    bios_printf("Boot from SD card\n");
    asm volatile("fence.i");
    IO_PORT(BOARD_LEDS) = 0x2;
    ((void (*)())BIOS_RAM_ADDR)();
  }

#ifndef SIMULATION
  bios_printf(
      "\nUART console. Commands:\n"
      "\tW addr val\t\t\t- save 4B to RAM\n"
      "\tR addr\t\t\t\t- load 4B from RAM\n"
      "\tSD addr sector\t\t- load SD card sector to addr\n"
      "\tUART addr size\t\t- receive size(decimal) bytes via UART\n"
      "\tFUART addr size\t   - UART with baud rate 12Mhz\n"
      "\tCRC32 addr size [expected] - calculate crc of data in RAM\n"
      "\tJ addr\t\t\t\t- run code at addr\n\n"
  );
#endif

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
      case 'J':
        if (bios_sscanf(cmd, "J %x", &addr) == 1) {
          asm volatile("fence.i");
          IO_PORT(BOARD_LEDS) = 0x2;
          ((void (*)())addr)();
          continue;
        }
        break;
    }
    bios_printf("Invalid command\n");
    uart_flush();
  }
}
