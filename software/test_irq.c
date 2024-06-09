#include <endeavour_defs.h>

int main() {
  bios_printf("aaa\n");
  asm volatile("csrw mie, %0" : : "r" (-1));
  asm volatile("csrsi mstatus, 8");
  bios_printf("bbb\n");
  return 0;
}
