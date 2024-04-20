#include <endeavour_defs.h>

int main() {
  int* ram = (int*)RAM_ADDR;
  for (int i = 0; i < 1024 * 1024; i += 1024) {
    ram[i]   = 0x5a000000 + i;
    ram[i+1] = 0x005a0001 + i;
    ram[i+2] = 0x00ff0002 + i;
    ram[i+3] = 0x00000003 + i;
  }
  for (int i = 0; i < 1024 * 1024; i += 1024 * 32) {
    bios_printf("%8x %8x %8x %8x\n", ram[i], ram[i+1], ram[i+2], ram[i+3]);
  }
  return 0;
}
