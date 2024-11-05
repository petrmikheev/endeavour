#include <endeavour_defs.h>
#include <endeavour_ext2.h>

#define LOAD_ADDR (void*)0x80400000ul

void run_kernel(void* addr);  // implemented in asm.S

static bool wait_for_user_interrupt() {
  bios_printf("[BOOT] Press any key to open console. Waiting...\n");
  unsigned start;
  asm volatile("csrr %0, time" : "=r" (start));
  while (1) {
    if (IO_PORT(BOARD_KEYS) || IO_PORT(UART_RX) >= 0) return 1;
    unsigned current;
    asm volatile("csrr %0, time" : "=r" (current));
    if (current - start > 1000000) return 0;
  }
}

static int strcmp(const char* s1, const char* s2) {
  while (*s1 == *s2 && *s1 != 0) {
    s1++;
    s2++;
  }
  if (*s1 > *s2)
    return 1;
  else if (*s1 < *s2)
    return -1;
  else
    return 0;
}

static int load_file(const char* path) {
  const struct Inode* inode = find_inode(path);
  if (!inode || !is_regular_file(inode)) {
    bios_printf("[BOOT] File not found\n");
    return 0;
  }
  if (read_file(inode, LOAD_ADDR, inode->size_lo) != inode->size_lo) {
    bios_printf("[BOOT] IO error\n");
    return 0;
  }
  return inode->size_lo;
}

static void run_command(char* cmd) {
  char* arg = cmd;
  while (*arg != 0 && *arg != ' ') arg++;
  if (*arg) *arg++ = 0;
  if (strcmp(cmd, "boot") == 0) {
    int size = load_file(arg);
    if (!size) return;
    bios_printf("[BOOT] Starting kernel; crc32 = %8x\n", bios_crc32(LOAD_ADDR, size));
    run_kernel(LOAD_ADDR);
  } else if (strcmp(cmd, "call") == 0) {
    if (load_file(arg)) ((void (*)())LOAD_ADDR)();
  } else if (strcmp(cmd, "cat") == 0) {
    int size = load_file(arg);
    if (size) {
      bios_printf("***\n");
      for (int i = 0; i < size; ++i) bios_putc(*(char*)(LOAD_ADDR + i));
      bios_printf("\n***\n");
    }
  } else if (strcmp(cmd, "ls") == 0) {
    const struct Inode* inode = find_inode(arg);
    if (inode && is_dir(inode))
      print_dir(inode);
    else
      bios_printf("[BOOT] Dir not found\n");
  } else if (strcmp(cmd, "display") == 0) {
    int w = 0, h = 0;
    bios_sscanf(arg, "%dx%d", &w, &h);
    unsigned cfg = IO_PORT(VIDEO_CFG) & ~3;
    if (w == 640 && h == 480)
      cfg |= 1;
    else if (w == 1024 && h == 768)
      cfg |= 2;
    else if (w == 1280 && h == 720)
      cfg |= 3;
    else {
      bios_printf("[BOOT] Invalid display mode\n");
      return;
    }
    IO_PORT(VIDEO_CFG) = cfg;
  } else if (strcmp(cmd, "options") == 0) {
    bios_printf("[BOOT] Not implemented\n");
    // TODO
  } else if (strcmp(cmd, "textstyle") == 0) {
    int fg = 0xffffff40, bg = 0;
    bios_sscanf(arg, "%x %x", &fg, &bg);
    IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_BG(0);
    IO_PORT(VIDEO_REG_VALUE) = bg;
    IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(15);
    IO_PORT(VIDEO_REG_VALUE) = fg;
  } else if (strcmp(cmd, "wallpaper") == 0) {
    if (!*arg) {
      IO_PORT(VIDEO_CFG) &= ~VIDEO_GRAPHIC_ON;
      return;
    }
    int size = load_file(arg);
    if (size != 70 + 2 * 720 * 1280) {  // TODO: Add proper BMP parsing
      if (size) bios_printf("[BOOT] Usupported wallpaper. Expected 1280x720 RGB565 BMP.\n");
      return;
    }
    char* frame_buffer  = (char*)RAM_ADDR + 0x100000;
    const char* wallpaper_bmp = LOAD_ADDR;
    IO_PORT(VIDEO_GRAPHIC_ADDR) = (long)frame_buffer;
    for (int j = 0; j < 720; ++j) {
      const char* src = wallpaper_bmp + 70 + (720-j-1) * (1280 * 2);
      char* dst = frame_buffer + j * (1024*4);
      for (int i = 0; i < 1280*2; ++i) dst[i] = src[i];
    }
    IO_PORT(VIDEO_CFG) |= VIDEO_GRAPHIC_ON;
  } else
    bios_printf("[BOOT] Invalid command\n");
}

#define MAX_BOOT_CONF_SIZE 4096
char conf_buffer[MAX_BOOT_CONF_SIZE];

int main() {
#ifdef RUN_PRELOADED_KERNEL
  bios_printf("[BOOT] Starting preloaded kernel\n");
  run_kernel((void*)LOAD_ADDR);
  // no return
#else
  if (!init_ext2_reader(/*partition_start=*/2048)) bios_wait_reset();
  if (wait_for_user_interrupt()) goto console;
  struct Inode* conf_file;
  if ((conf_file = find_inode("/boot/conf")) && is_regular_file(conf_file)) {
    bios_printf("[BOOT] Processing /boot/conf\n");
    int size = conf_file->size_lo < MAX_BOOT_CONF_SIZE ? conf_file->size_lo : MAX_BOOT_CONF_SIZE;
    if (read_file(conf_file, conf_buffer, size) != size) {
      bios_printf("[BOOT] IO error\n");
      goto console;
    }
    conf_buffer[MAX_BOOT_CONF_SIZE-1] = 0;
    int pos = 0;
    while (pos < size && conf_buffer[pos] != 0) {
      int cend = pos;
      while (cend < size && conf_buffer[cend] != 0 && conf_buffer[cend] != '\n') cend++;
      if (conf_buffer[cend] != 0) {
        conf_buffer[cend++] = 0;
      }
      if (conf_buffer[pos] != '#' && conf_buffer[pos] != 0) {
        bios_printf("[BOOT] > ");
        bios_printf(conf_buffer + pos);
        bios_putc('\n');
        run_command(conf_buffer + pos);
      }
      pos = cend;
    }
  } else {
    bios_printf("[BOOT] /boot/conf not found\n");
  }
console:
  bios_printf(
    "[BOOT] Commands:\n"
    "\tboot <path>\t\t\t- load and start linux kernel (exit bootloader)\n"
    "\tcall <path>\t\t\t- load and run binary file as a function\n"
    "\tcat  <path>\t\t\t- print content of a text file\n"
    "\tdisplay WIDTHxHEIGHT   - choose display resolution 640x480 / 1024x768 / 1280x720\n"
    "\tls   <path>\t\t\t- show files in a dir\n"
    "\toptions <any string>   - set linux kernel arguments\n"
    "\ttextstyle <fg> <bg>\t- set text/background RGBA color. Default: FFFFFF40 00000000\n"
    "\twallpaper <path>   \t- load bmp file as a wallpaper\n\n"
  );
  while (1) {
    bios_printf("> ");
    int size = bios_gets(conf_buffer, MAX_BOOT_CONF_SIZE);
    if (size > 0) {
      conf_buffer[size - 1] = 0;
      run_command(conf_buffer);
    }
  }
#endif
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
  if (ext_id == SBI_EXT_ENDEAVOUR) {
    if (fn_id == 0) {  // print char
      bios_putc(arg);
      return (struct sbiret){SBI_OK, 0};
    }
    if (fn_id == 1) {
      return (struct sbiret){SBI_OK, SDCARD_SECTOR_COUNT};
    }
    if (fn_id == 2) {
      return (struct sbiret){SBI_OK, SDCARD_RCA};
    }
  }
  if (ext_id == 0x10) {
    if (fn_id == 0) return (struct sbiret){SBI_OK, 2}; // SBI spec version -> 0.2
    if (fn_id == 3) {
      if (arg == SBI_EXT_TIMER) return (struct sbiret){SBI_OK, 1};
      if (arg == SBI_EXT_RESET) return (struct sbiret){SBI_OK, 1};
#ifdef SBI_DEBUG
      bios_printf("[SBI] Probing extension 0x%x\n", arg);
#endif
      return (struct sbiret){SBI_OK, 0};
    }
    return (struct sbiret){SBI_OK, 0};
  }
  // Note: SBI_EXT_TIMER is handled in asm.S
  if (ext_id == SBI_EXT_RESET) {
#ifdef SBI_DEBUG
    bios_printf("[SBI] Reset requested. Send any byte to UART.\n");
    bios_wait_reset();
#else
    bios_reset();
#endif
  }
#ifdef SBI_DEBUG
  bios_printf("[SBI] Function not supported ext=0x%x, fn=0x%x, arg=0x%x\n", ext_id, fn_id, arg);
#endif
  return (struct sbiret){SBI_NOT_SUPPORTED, 0};
}
