#include "tty.h"

#include <stdio.h>
#include <string.h>

#include "textwm.h"
#include "utf8.h"

struct TTY ttys[TTY_COUNT];

static char* tty_cursor_ptr(struct TTY* tty) {
  return tty->frame + ((tty->frame_start + (tty->line << 9) | (tty->column << 1)) & 0xffff);
}

static void maybe_scroll(struct TTY *tty) {
  if (tty->column >= tty->width) {
    tty->column -= tty->width;
    tty->line++;
  }
  while (tty->line >= tty->height) {
    tty->line--;
    int v = ((int)(tty->style|8) << 8) | ((int)(tty->style|8) << 24);
    int* line = (int*)(tty->frame + ((tty->frame_start + (tty->height<<9)) & 0xffff));
    for (int i = 0; i < 128; ++i) line[i] = v;
    line = (int*)(tty->frame + ((tty->frame_start + (tty->height<<9) + 512) & 0xffff));
    tty->frame_start = (tty->frame_start + 512) & 0xffff;
    for (int i = 0; i < 128; ++i) line[i] = v;
    update_taddr(tty - ttys);
  }
}

static void tty_print(struct TTY *tty, unsigned ucode) {
  maybe_scroll(tty);
  char* cursor = tty_cursor_ptr(tty);
  int c = from_utf(ucode, tty->bold);
  if (c < 0) c = '?';
  cursor[0] = c & 0xff;
  cursor[1] = tty->style | (8 & ~(c >> 5));
  tty->column += 1;
}

static void tty_sgr(struct TTY *tty) {
  tty->style = 0x7;
  tty->bold = false;
  int i = 0;
  const char* s = tty->csi;
  while (*s >= '0' && *s <= '9') {
    int c = 0;
    while (*s >= '0' && *s <= '9') c = c * 10 + *s++ - '0';
    if (*s == ';') s++;
    if (c == 0 || c == 10) { /* ignore */ }
    else if (c == 7) tty->style = 0xf0; //((tty->style&15) << 4) || (tty->style >> 4) & 7 | 0x80;
    else if (c == 1 || c == 4) tty->bold = true;
    else if (c >= 30 && c <= 37) tty->style = (tty->style & 0xf0) | (c - 30);
    else if (c == 39) tty->style = (tty->style & 0xf0) | 7;
    else if (c >= 40 && c <= 47) tty->style &= ((c - 40) << 4) | 0x80;
    else if (c == 49) tty->style &= 0xf;
    else {
      printf("[textwm] SGR %d not implemented\n", c);
    }
  }
}

static void tty_csi(int tty_id) {
  struct TTY *tty = &ttys[tty_id];
  tty->csi[tty->csi_len] = 0;
  if (tty->csi_len == 0) goto err;
  //printf("[textwm] %d:%d CSI: %s\n", tty->line, tty->column, tty->csi);
  if (strcmp(tty->csi, "?1049h") == 0) {
    tty->frame = display_data + ((tty_id + TTY_COUNT) << 16);
    update_taddr(tty_id);
    return;
  }
  if (strcmp(tty->csi, "?1049l") == 0) {
    tty->frame = display_data + (tty_id << 16);
    update_taddr(tty_id);
    return;
  }
  if (tty->column >= tty->width) {
    tty->column -= tty->width;
    tty->line++;
  }
  int n = 1, m = 1;
  switch (tty->csi[tty->csi_len - 1]) {
    case 'F':
      tty->column = 0;
    case 'A':
      sscanf(tty->csi, "%d", &n);
      tty->line -= n;
      break;
    case 'E':
      tty->column = 0;
    case 'B':
      sscanf(tty->csi, "%d", &n);
      tty->line += n;
      break;
    case 'b': {
      sscanf(tty->csi, "%d", &n);
      m = (unsigned)(tty->style | 8) << 8;
      int cpos = (tty->frame_start + (tty->line << 9) | (tty->column << 1)) & 0xffff;
      int to = (cpos + (n<<1)) & 0xffff;
      for (int i = cpos; i != to; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      tty->column += n;
      break;
    }
    case 'P': {
      sscanf(tty->csi, "%d", &n);
      char* cur = tty_cursor_ptr(tty);
      char* line_end = (char*)((long)(cur + 512) & ~511);
      n <<= 1;
      if (cur + n > line_end) n = line_end - cur;
      for (char* p = cur; p < line_end - n; ++p) *p = p[n];
      break;
    }
    case 'C':
      sscanf(tty->csi, "%d", &n);
      tty->column += n;
      break;
    case 'D':
      sscanf(tty->csi, "%d", &n);
      tty->column -= n;
      break;
    case 'G':
      sscanf(tty->csi, "%d", &n);
      tty->column = n - 1;
      break;
    case 'd':
      sscanf(tty->csi, "%d", &n);
      tty->line = n - 1;
      break;
    case 'f':
    case 'H':
      if (tty->csi[0] == ';')
        sscanf(tty->csi, "%d", &m);
      else
        sscanf(tty->csi, "%d;%d", &n, &m);
      tty->line = n - 1;
      tty->column = m - 1;
      break;
    case 'm':
      tty_sgr(tty);
      break;
    case 'J':
      n = 0;
      sscanf(tty->csi, "%d", &n);
      m = (unsigned)(tty->style | 8) << 8;
      int cpos = (tty->frame_start + (tty->line << 9) | (tty->column << 1)) & 0xffff;
      int frame_end = (tty->frame_start + (tty->height << 9)) & 0xffff;
      if (n == 0) {
        for (int i = cpos; i != frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      } else if (n == 1) {
        for (int i = tty->frame_start; i != cpos; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      } else if (n == 2) {
        for (int i = tty->frame_start; i != frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      }
      break;
    case 'K': {
      n = 0;
      sscanf(tty->csi, "%d", &n);
      int cpos = (tty->frame_start + (tty->line << 9) | (tty->column << 1)) & 0xffff;
      int from = cpos, to = cpos;
      if (n == 0) {
        to = (cpos + 0x200) & ~0x1ff;
      } else if (n == 1) {
        from = cpos & ~0x1ff;
      } else if (n == 2) {
        from = cpos & ~0x1ff;
        to = (cpos + 0x200) & ~0x1ff;
      }
      unsigned v = (unsigned)(tty->style | 8) << 8;
      for (char* p = tty->frame + from; p != tty->frame + to; p += 2) *(short*)p = v;
      break;
    }
    case 'S':
      sscanf(tty->csi, "%d", &n);
      n = n << 9;
      tty->frame_start = (tty->frame_start - n) & 0xffff;
      update_taddr(tty_id);
      break;
    case 'T':
      sscanf(tty->csi, "%d", &n);
      n = n << 9;
      tty->frame_start = (tty->frame_start + n) & 0xffff;
      update_taddr(tty_id);
      break;
    default: goto err;
  }
  if (tty->line < 0) tty->line = 0;
  if (tty->column < 0) tty->column = 0;
  while (tty->column >= tty->width) {
    tty->column -= tty->width;
    tty->line++;
  }
  if (tty->line >= tty->height) tty->line = tty->height - 1;
  return;
err:
  printf("[textwm] Can't process CSI: %s\n", tty->csi);
}

void tty_handler(int tty_id, char c) {
  struct TTY *tty = &ttys[tty_id];
  //printf("TTY%d %d frame_start=%d cursor=%d frame_end=%d\n", tty_id, c, tty->frame_start, tty->cursor, tty->frame_end);
  if (tty->state == 0) {
    switch (c) {
      case 7: break; // beep
      case 0xc: tty->line = tty->column = 0; break;
      case 0x1b: tty->state = 'e'; break; // start escape
      case '\r': tty->column = 0; break;
      case '\n':
        tty->line++;
        maybe_scroll(tty);
        break;
      case '\t': tty->column = (tty->column + 7) & ~7; break;
      case '\b':
        if (tty->column > 0) {
          tty->column--;
        } else if (tty->line > 0) {
          tty->line--;
          tty->column = tty->width - 1;
        }
        break;
      default:
        if (c & 128) {
          tty->state = 'u'; // utf8
          if ((c & 32) == 0) {
            tty->ucount = 2;
            tty->ucode = c & 31;
          } else if ((c & 16) == 0) {
            tty->ucount = 3;
            tty->ucode = c & 15;
          } else {
            tty->ucount = 4;
            tty->ucode = c & 7;
          }
        } else {
          tty_print(tty, c);
        }
    }
  } else if (tty->state == 'e') {
    tty->csi_len = 0;
    switch (c) {
      case '[':
        tty->state = '[';  // CSI
        break;
      case '>':
      case '=':
        tty->state = 0;  // keypad mode, ignore
        break;
      case '(':
      case ')':
        tty->state = '('; // ignore next char
        break;
      default:
        printf("[textwm] Escape sequence \\e%c... (%d) not supported\n", c, c);
        tty->state = 0;
    }
  } else if (tty->state == '(') {
    tty->state = 0;
  } else if (tty->state == 'u') {
    tty->ucode = (tty->ucode << 6) | (c&0x3f);
    if (--tty->ucount == 1) {
      tty->state = 0;
      tty_print(tty, tty->ucode);
    }
  } else if (tty->state == '[') {
    tty->csi[tty->csi_len++] = c;
    if ((c >= 0x40 && c <= 0x7e) || tty->csi_len == CSI_MAX_LEN - 1) {
      tty->state = 0;
      tty_csi(tty_id);
    }
  } else {
    printf("[textwm] Invalid state %c\n", tty->state);
  }
}

int active_tty = 0;

void tty_set_active(int tty_id) {
  if (tty_id >= 0 && tty_id < TTY_COUNT && tty_id != active_tty) {
    printf("[textwm] active tty = %d\n", tty_id);
    active_tty = tty_id;
    update_taddr(active_tty);
  }
}

static char swap_fg_bg(char style) {
  int bg = 8 | (style & 7);
  int fg = (style & 0x80) ? ((style >> 4) & 7) : 0;
  return (style & 8) | fg | (bg << 4);
}

void hide_cursor(struct TTY *tty) {
  if (!tty->cursor_visible) return;
  tty_cursor_ptr(tty)[1] = tty->style_at_cursor;
  tty->cursor_visible = false;
}

void show_cursor(struct TTY *tty) {
  if (tty->cursor_visible) return;
  char* cursor = tty_cursor_ptr(tty);
  tty->style_at_cursor = cursor[1];
  cursor[1] = swap_fg_bg(tty->style_at_cursor);
  tty->cursor_visible = true;
}
