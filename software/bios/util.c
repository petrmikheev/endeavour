#include <endeavour_defs.h>

void init_text_mode() {
  const int video_mode = VIDEO_1280x720;
  const int line_count = video_mode == VIDEO_1280x720 ? 45 : (video_mode == VIDEO_1024x768 ? 48 : 30);
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_BG(0);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(0, 0, 0) | VIDEO_TEXT_ALPHA(0);  // text styles 0x0? - black background
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(15);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(255, 255, 255) | VIDEO_TEXT_ALPHA(64);  // text styles 0x?F - white text
  const unsigned* charmap_ptr = (const unsigned*)BIOS_CHARMAP_ADDR;
  for (int i = 32 * 4; i < 127 * 4; ++i) {
    IO_PORT(VIDEO_REG_INDEX) = i;
    IO_PORT(VIDEO_REG_VALUE) = *charmap_ptr++;
  }
  unsigned* text_buf = (unsigned*)RAM_ADDR;
#ifndef SIMULATION
  for (int i = 0; i < 128 * line_count; ++i) {
#else
  for (int i = 0; i < 32; ++i) {
#endif
    text_buf[i] = (BIOS_DEFAULT_TEXT_STYLE << 8) | (BIOS_DEFAULT_TEXT_STYLE << 24);
  }
  BIOS_TEXT_STYLE = BIOS_DEFAULT_TEXT_STYLE;
  BIOS_CURSOR_POS = 0;
  BIOS_SCREEN_END_POS = 512 * line_count;
  IO_PORT(VIDEO_TEXT_ADDR) = RAM_ADDR;
  IO_PORT(VIDEO_CFG) = video_mode | VIDEO_TEXT_ON | VIDEO_FONT_WIDTH(8) | VIDEO_FONT_HEIGHT(16);
}

static void uart_putc(char c) {
  while (IO_PORT(UART_TX) < 0);
  IO_PORT(UART_TX) = c;
}

void putc_impl(char c) {
  int cursor_pos = BIOS_CURSOR_POS;
  char* cursor = (char*)(BIOS_TEXT_BUFFER_ADDR + cursor_pos);
  if (c == '\n') {
    cursor_pos = (cursor_pos & ~511) + 512;
  } else if (c == '\b') {
    cursor[-2] = 0;
    cursor[-1] = BIOS_TEXT_STYLE;
    cursor_pos -= 2;
    uart_putc('\b');
    uart_putc(' ');
  } else {
    cursor[0] = c;
    cursor[1] = BIOS_TEXT_STYLE;
    cursor_pos += 2;
  }
  cursor_pos &= (VIDEO_TEXT_BUFFER_SIZE - 1);
  if (cursor_pos == BIOS_SCREEN_END_POS) {
    int* line = (int*)(BIOS_TEXT_BUFFER_ADDR + cursor_pos);
    for (int i = 0; i < 128; ++i) line[i] = (BIOS_DEFAULT_TEXT_STYLE << 8) | (BIOS_DEFAULT_TEXT_STYLE << 24);
    BIOS_SCREEN_END_POS = (BIOS_SCREEN_END_POS + 512) & (VIDEO_TEXT_BUFFER_SIZE - 1);
    IO_PORT(VIDEO_TEXT_ADDR) = BIOS_TEXT_BUFFER_ADDR | ((IO_PORT(VIDEO_TEXT_ADDR) + 512) & (VIDEO_TEXT_BUFFER_SIZE - 1));
  }
  BIOS_CURSOR_POS = cursor_pos;
  uart_putc(c);
}

static void print_number(unsigned v, unsigned base, int width) {
  char buf[32];
  char* ptr = buf;
  while (v > 0 || width > 0) {
    *ptr++ = v % base;
    v /= base;
    width--;
  }
  while (ptr != buf) putc_impl("0123456789ABCDEF"[*--ptr]);
}

void printf_impl(const char* fmt, unsigned a1, unsigned a2, unsigned a3, unsigned a4, unsigned a5, unsigned a6, unsigned a7)
{
  unsigned args[7] = {a1, a2, a3, a4, a5, a6, a7};
  unsigned* arg = args;
  char c;
  while ((c = *fmt++) != 0) {
    if (c == '\t') {
      for (int i = 0; i < 4; ++i) putc_impl(' ');
      continue;
    }
    if (c != '%') {
      putc_impl(c);
      continue;
    }
    char f = *fmt++;
    if (f == '%') {
      putc_impl('%');
      continue;
    }
    int width = 1;
    while (f >= '0' && f <= '9') {
      width = f - '0';
      f = *fmt++;
    }
    if (f == 0) break;
    unsigned a = *arg;
    switch (f) {
      case 'B': print_number(a, 2, width * 8); break;
      case 'x': print_number(a, 16, width); break;
      case 'c': putc_impl(a); break;
      case 'd':
        if ((int)a < 0) {
          putc_impl('-');
          a = -a;
        }
        // no break
      case 'u':
        print_number(a, 10, width);
        break;
      default:
        putc_impl('%');
        putc_impl(f);
    }
    arg++;
  }
}

unsigned parse_int(const char** str, int base) {
  unsigned res = 0;
  while (1) {
    char c = **str;
    if (c >= '0' && c <= '9') {
      res = res * base + (c - '0');
    } else if (c >= 'a' && c <= 'f') {
      res = res * base + (c - 'a' + 10);
    } else if (c >= 'A' && c <= 'F') {
      res = res * base + (c - 'A' + 10);
    } else {
      return res;
    }
    (*str)++;
  }
  return res;
}

int sscanf_impl(const char* str, const char* fmt, unsigned* a1, unsigned* a2, unsigned* a3, unsigned* a4, unsigned* a5, unsigned* a6) {
  unsigned* args[7] = {a1, a2, a3, a4, a5, a6};
  unsigned** arg = args;
  while (1) {
    char f = *fmt++;
    if (f == 0) break;
    if (f == '%') {
      int base = *fmt++ == 'd' ? 10 : 16;
      *(*arg++) = parse_int(&str, base);
    } else {
      if (f != *str++) break;
    }
  }
  return arg - args;
}

static void wait(volatile int i) {
  while (i > 0) i--;
}

void uart_flush() {
  while (1) {
    wait(16384);
    if (IO_PORT(UART_RX) < 0) {
      IO_PORT(UART_RX) = 0;
      return;
    }
    while (IO_PORT(UART_RX) >= 0);
  }
}

int uart_getc(int show_cursor) {
  int x;
  char* cursor = (char*)(BIOS_TEXT_BUFFER_ADDR + BIOS_CURSOR_POS);
  if (show_cursor) cursor[1] = BIOS_TEXT_STYLE;
  do {
    if (show_cursor) {
      unsigned time;
      asm volatile("csrr %0, time" : "=r" (time));
      cursor[0] = (time & (1<<19)) ? '_' : 0;
    }
    x = IO_PORT(UART_RX);
  } while (x < 0);
  if (show_cursor) cursor[0] = 0;
  if (x > 0xff) IO_PORT(BOARD_LEDS) |= 0x4;  // third LED means UART error
  return x;
}

int uart_read(char* dst, int size, int divisor) {
  unsigned uart_cfg = IO_PORT(UART_CFG);
  if (divisor >= 0) {
    IO_PORT(UART_CFG) = (IO_PORT(UART_CFG) & 0xffff0000) | divisor;
  }
  for (int i = 0; i < size; ++i) {
    int x;
    do { x = IO_PORT(UART_RX); } while (x < 0);
    if (x < 0x100) {
      *(dst++) = (char)x;
    } else {
      IO_PORT(BOARD_LEDS) |= 0x4;  // third LED means UART error
      uart_flush();
      if (divisor >= 0) {
        IO_PORT(UART_CFG) = uart_cfg;
        wait(2<<18);
      }
      bios_printf("Error %d at pos %d\n", x>>8, i);
      return 0;
    }
  }
  if (divisor >= 0) {
    IO_PORT(UART_CFG) = uart_cfg;
    wait(2<<18);
  }
  return 1;
}

int gets_impl(char* buf, int max_size) {
  char c;
  int size = 0;
  do {
    c = uart_getc(1);
    if (c == '\r') c = '\n';
    if (c == '\b' && size > 0) {
      size--;
      bios_putc('\b');
    }
    if (c < 32 && c != '\n') continue;
    bios_putc(c);
    buf[size++] = c;
  } while (size < max_size && c != '\n');
  return size;
}

unsigned crc32_impl(const char* data, int size) {
  unsigned table[16];
  for (int i = 0; i < 16; ++i) {
    unsigned c = i;
    unsigned crc = 0;
    for (int j = 0; j < 4; ++j) {
      int b = (c ^ crc) & 1;
      crc >>= 1;
      if (b) crc = crc ^ 0xedb88320;
      c >>= 1;
    }
    table[i] = crc;
  }

  unsigned ncrc = 0xffffffff;
  for (int i = 0; i < size; ++i) {
    unsigned c = data[i];
    ncrc = (ncrc>>4) ^ table[(c^ncrc) & 0xf];
    c >>= 4;
    ncrc = (ncrc>>4) ^ table[(c^ncrc) & 0xf];
  }
  return ~ncrc;
}
