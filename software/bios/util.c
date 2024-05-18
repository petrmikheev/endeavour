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
    if (f >= '0' && f <= '9') {
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
