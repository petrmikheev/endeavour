#include <endeavour_defs.h>

typedef char bool;

void set_LEDs(unsigned v) {
  *(volatile unsigned*)GPIO_ADDR = v;
}

// Returns next received UART byte, or a negative number
int UART_getc() {
  return *(volatile int*)UART_RX_ADDR;
}

bool UART_is_busy() {
  return *(volatile int*)UART_TX_ADDR >= 0;
}

void UART_putc(char c) {
  while (UART_is_busy());
  *(volatile unsigned*)UART_TX_ADDR = c;
}

void UART_puts(const char* s) {
  while (*s) UART_putc(*(s++));
}

void wait(unsigned t) {
  for (volatile unsigned i = 0; i < t; ++i);
}

void main() {
  UART_puts("Endeavour\r\n");
  while (1) {
    set_LEDs(LED0);
    wait(1000000);
    set_LEDs(LED1);
    wait(1000000);
    set_LEDs(LED2);
    wait(1000000);
    set_LEDs(LED1);
    wait(1000000);
  }
}

