#include <endeavour_defs.h>

struct I2C {
  unsigned addr, conf, data;
};

#define WRITE      0
#define READ       1
#define HIGH_SPEED 2
#define ACTIVE     4
#define READ_NACK  8
#define DATA_ERR   0x10
#define ADDR_ERR   0x20
#define HAS_DATA   0x40

volatile struct I2C *pll = (void*)0xb000;
volatile struct I2C *dac = (void*)0xc000;
volatile struct I2C *pllb = (void*)0xd000;

#define wtime 1000

int err_count = 0;

void write(volatile struct I2C* i2c, int v) {
  i2c->data = v;
  while (i2c->conf & HAS_DATA);
  if (i2c->conf & DATA_ERR) err_count++;
}

int read(volatile struct I2C* i2c) {
  while (!(i2c->conf & HAS_DATA));
  return i2c->data;
}

void halt(volatile struct I2C* i2c) {
  i2c->conf = 0;
  for (volatile int i = 0; i < wtime; ++i);
}

void dac_print_state() {
  halt(dac);
  dac->conf = ACTIVE | READ;

  for (int i = 0; i < 4; ++i) {
    bios_putc('A' + i);
    char data[6];
    for (int j = 0; j < 6; ++j) data[j] = read(dac);
    bios_printf(": %2x %2x %2x %2x %2x %2x", data[0], data[1], data[2], data[3], data[4], data[5]);
    bios_printf(" -> 0x%3x\n", data[2] | ((data[1] & 0xf) << 8));
  }
  halt(dac);
}

void dac_set(int channel, int value) {
  write(dac, 0x40 + channel * 2);
  write(dac, value >> 8);
  write(dac, value);
}

int get_time() {
  int time;
  asm volatile("csrr %0, time" : "=r" (time));
  return time;
}

/*void print_pll_regs(volatile struct I2C* i2c) {
  for (volatile int i = 0; i < wtime; ++i);
  i2c->conf = ACTIVE | WRITE;
  write(i2c, 0);
  halt(i2c);
  i2c->conf = ACTIVE | READ;
  const int count = 16;
  for (int i = 0; i < count - 1; ++i) {
    int r = read(i2c);
    if (i == count - 2) i2c->conf = ACTIVE | READ | READ_NACK;
    bios_printf("%02x ", r);
    if (i % 8 == 7) bios_putc('\n');
  }
  while (!(i2c->conf & HAS_DATA));
  halt(i2c);
  bios_printf("%02x\n", i2c->data);
}*/

void set_volume(int v) {
  dac_set(0, 0x0);
  for (int j = 0; j < 16; ++j) {
    //for (volatile int i = 0; i < 1000; ++i);
    dac_set(3, 0xfff);
    //for (volatile int i = 0; i < 1000; ++i);
    dac_set(3, 0x000);
  }
  dac_set(0, 0xfff);
  for (int j = 0; j < v; ++j) {
    //for (volatile int i = 0; i < 1000; ++i);
    dac_set(3, 0xfff);
    //for (volatile int i = 0; i < 1000; ++i);
    dac_set(3, 0x000);
  }
}

int main() {
  bios_printf("\n\nI2C test\n");
  pll->conf = 0x0;
  pllb->conf = 0x0;
  dac->conf = 0x0;
  pll->addr = 0x60;
  pllb->addr = 0x60;
  dac->addr = 0x60;

  //dac_print_state();

  /*bios_printf("\nPLLA\n");
  print_pll_regs(pll);
  bios_printf("\nPLLB\n");
  print_pll_regs(pllb);*/

  /*dac->conf = ACTIVE | WRITE;
  dac_set(1, 0x111);
  dac_set(2, 0x222);
  dac_set(0, 0x333);
  dac_set(3, 0x444);
  halt(dac);*/

  //dac_print_state();

  dac->conf = ACTIVE | WRITE | HIGH_SPEED;

  set_volume(4);

  int data[8] = {0x800, 0xda8, 0xfff, 0xda8, 0x800, 0x257, 0x000, 0x257};
  int next = get_time();
  for (int i = 0; i < 440; ++i) {
    for (int j = 0; j < 8; ++j) {
      dac_set(1, data[j]);
      dac_set(2, data[j]);
      next += (125000 / 440);
      while ((next - get_time()) > 0);
    }
  }

  //dac_print_state();
  halt(dac);

  bios_printf("addr err: plla=%d dac=%d pllb=%d\n", (pll->conf & ADDR_ERR) != 0, (dac->conf & ADDR_ERR) != 0, (pllb->conf & ADDR_ERR) != 0);
  pll->conf = 0x0;
  dac->conf = 0x0;
  return 0;
}
