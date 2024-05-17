#include <endeavour_defs.h>

int main() {
  unsigned* addr = (unsigned*)0x40002400;
  bios_sdread(addr, 3584 * 8, 4);
  bios_printf("[BOOTLOADER] Starting /hello_world.bin\n");
  IO_PORT(BOARD_LEDS) = 7;
  return ((int (*)())addr)();
}
