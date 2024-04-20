#include <endeavour_defs.h>

int main() {
  bios_printf("SD bootloader\n");
  IO_PORT(BOARD_LEDS) = 7;
  while(1);
}
