#include <endeavour_defs.h>

void putc_impl(char c) {
  while (IO_PORT(UART_TX) < 0);
  IO_PORT(UART_TX) = c;
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
