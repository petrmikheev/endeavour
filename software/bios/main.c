#include <endeavour_defs.h>

#include "bios.h"

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
  bios_printf("RAM: %uMB\tfreq=%uMHz\tmemtest", RAM_SIZE >> 20, IO_PORT(BOARD_RAM_FREQ) / 1000000);
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
  int check_count = 0;
  int err_count = 0;
  i = 8192, j = 8192;
  for (int b = 0; b < 4; ++b, j -= batch_size) {
    const int step = base_step + (b & 1);
    for (; j < batch_size; j += step, i += step, check_count++) {
      char* ptr = ram + (i << 2);
      unsigned expected = (i | (i << 25)) ^ 0xff00;
      unsigned actual = *(unsigned*)ptr;
      if (*(ptr + 3) != (expected >> 24)  // test 1 byte read
          || actual != expected) {    // test 4 byte read
        if (++err_count <= 8) {
          bios_printf("\n\tmem[%8x] = %8x, expected %8x", i << 2, actual, expected);
        }
      }
    }
    bios_putc('.');
  }
  if (err_count) {
    bios_printf("\nFAILED %u/%u errors\n", err_count, check_count);
  } else {
    bios_printf(" OK\n");
  }
  return err_count == 0;
}

int main() {
  IO_PORT(BOARD_LEDS) = 0x1;  // first LED on, means that bios has started
  IO_PORT(USB_OHCI_BASE + 0x4) = 0;  // switch USB hub to reset state
#ifndef SIMULATION
  IO_PORT(UART_CFG) = UART_BAUD_RATE(115200) | UART_PARITY_EVEN | UART_CSTOPB;
  IO_PORT(AUDIO_CFG) = AUDIO_SAMPLE_RATE(2400) | AUDIO_VOLUME(3); // beep 300Hz
  bios_beep(0, 90);
  bios_beep(256, 90);
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
  if (!memtest_ok) {
    bios_beep(0, 90);
    bios_beep(256, 300);
  }
#else
  int memtest_ok = (IO_PORT(BOARD_KEYS) & 1) || memtest();
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
    bios_beep(0, 90);
    bios_beep(256, 90);
    asm volatile("fence.i");
    IO_PORT(BOARD_LEDS) = 0x2;
    ((void (*)())BIOS_RAM_ADDR)();
  }

#ifndef SIMULATION
  bios_printf(console_help_msg);
#endif

  uart_console();
}
