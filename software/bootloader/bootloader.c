#include <endeavour_defs.h>

void run_kernel(void* addr);

#define KERNEL_ADDR 0x80400000ul

int main() {
#ifndef SKIP_READ
  if (SDCARD_SECTOR_COUNT < 4096) {
    bios_printf("[BOOTLOADER] No SD card\n");
    bios_wait_reset();
  }
  // TODO
#endif
  run_kernel((void*)KERNEL_ADDR);
  // no return
}

// *** SBI implementation

#define SBI_DEBUG

#define SBI_OK 0
#define SBI_NOT_SUPPORTED -2

#define SBI_EXT_TIMER 0x54494D45
#define SBI_EXT_RESET 0x53525354
#define SBI_EXT_ENDEAVOUR 0x0A000000

void fatal_trap_handler(unsigned cause, unsigned tval, unsigned epc, unsigned sp, unsigned ra) {
  bios_printf("\n[SBI] TRAP\n\tcause = %8x\n\ttval  = %8x\n\tepc   = %8x\n\tsp\t= %8x\n\tra\t= %8x\n",
              cause, tval, epc, sp, ra);
  bios_wait_reset();
}

struct sbiret {
  int error;
  int value;
};

struct sbiret sbi_handler(int arg, int argh, int fn_id, int ext_id) {
  if (ext_id == SBI_EXT_ENDEAVOUR && fn_id == 0) {
    bios_putc(arg);
    return (struct sbiret){SBI_OK, 0};
  }
#ifdef SBI_DEBUG
  bios_printf("[SBI] ext=0x%x, fn=0x%x, arg=0x%x\n", ext_id, fn_id, arg);
#endif
  if (ext_id == 0x10) {
    if (fn_id == 0) return (struct sbiret){SBI_OK, 2}; // SBI spec version -> 0.2
    if (fn_id == 3) {
      // if (arg == SBI_EXT_TIMER) return (struct sbiret){SBI_OK, 0};
      if (arg == SBI_EXT_RESET) return (struct sbiret){SBI_OK, 1};
      return (struct sbiret){SBI_OK, 0};
    }
    return (struct sbiret){SBI_OK, 0};
  }
#ifdef SBI_DEBUG
  if (ext_id == SBI_EXT_TIMER && fn_id == 0) {
    bios_printf("[SBI] sbi_set_timer not implemented\n");
  }
#endif
  if (ext_id == SBI_EXT_RESET) {
#ifdef SBI_DEBUG
    bios_printf("[SBI] Reset requested. Send any byte to UART.\n");
    bios_wait_reset();
#else
    bios_reset();
#endif
  }
  return (struct sbiret){SBI_NOT_SUPPORTED, 0};
}
