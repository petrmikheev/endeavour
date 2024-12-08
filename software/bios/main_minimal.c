#include <endeavour_defs.h>

#include "bios.h"

int memtest() { return 1; }

int main() {
  int sim = (IO_PORT(BOARD_KEYS) & 2);
  IO_PORT(BOARD_LEDS) = 0x1;  // first LED on, means that bios has started
  IO_PORT(UART_CFG) = sim ? UART_BAUD_RATE(16000000) | UART_PARITY_EVEN | UART_CSTOPB
                          : UART_BAUD_RATE(115200) | UART_PARITY_EVEN | UART_CSTOPB;
  while (IO_PORT(UART_RX) >= 0);  // clear UART input buffer
  IO_PORT(UART_RX) = 0;  // clear UART framing error flag

#ifndef NO_DISPLAY
  init_text_mode();
#endif

  bios_printf(
      "\n\n"
      "\t\t\tEndeavour minimal\n"
      "\t\t\t=================\n\n"
  );
  bios_printf("clk0 %uMhz\n", IO_PORT(BOARD_RAM_FREQ) / 1000000);
  bios_printf("clk2 %uMhz\n", IO_PORT(BOARD_CPU_FREQ) / 1000000);

  uart_console();
}
