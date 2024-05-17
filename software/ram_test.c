#include <endeavour_defs.h>

void drop_cache() {
  asm volatile(".word 0x500F");
}

void print16b(int* arr) {
  bios_printf("%8x %8x %8x %8x\n", arr[0], arr[1], arr[2], arr[3]);
}

int main() {
  //IO_PORT(VIDEO_CFG) = VIDEO_1280x720 | VIDEO_FONT_WIDTH(8) | VIDEO_FONT_HEIGHT(16);
  int* ram = (int*)RAM_ADDR;
  /*for (int i = 0; i < 1024 * 128; i += 1024) {
    ram[i]   = 0x5a000000 + i;
    ram[i+1] = 0x005a0001 + i;
    ram[i+2] = 0x00ff0002 + i;
    ram[i+3] = 0x00000003 + i;
  }
  for (int i = 0; i < 1024 * 128; i += 1024 * 32) {
    bios_printf("%8x %8x %8x %8x\n", ram[i], ram[i+1], ram[i+2], ram[i+3]);
  }*/
  /*for (int i = 0; i < 128; ++i) ram[i] = 0xffffffff;
  drop_cache();
  print16b(ram);*/
  bios_printf("fill\n");
  for (int i = 0; i < 128 * 1024 * 1024 / 4; ++i) {
    ram[i] = i | (i << 25);
  }
  bios_printf("test\n");
  bios_printf("ram[0:3] = %8x %8x %8x %8x\n", ram[0], ram[1], ram[2], ram[3]);
  int err_count = 0;
  int last_ok = 1;
  int msg = 0;
  for (int i = 0; i < 128 * 1024 * 1024 / 4; ++i) {
    int ok = ram[i] == (i | (i << 25));
    err_count += ok ? 0 : 1;
    if (msg < 20) {
      if (ok && !last_ok) {
        msg++;
        bios_printf("ram[%d] = %8x OK\n", i, ram[i]);
      }
      if (!ok && last_ok) {
        msg++;
        bios_printf("ram[%d] = %8x FAILED\n", i, ram[i]);
      }
    }
    last_ok = ok;
  }
  bios_printf("errors %d/33554432\n", err_count);
  return 0;
}
