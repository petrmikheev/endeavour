#include "tty.h"

#include <stdio.h>
#include <string.h>

#include "textwm.h"
#include "utf8.h"

struct TTY ttys[TTY_COUNT];

static void tty_print(struct TTY *tty, unsigned ucode) {
  char* cursor = tty->frame + tty->cursor;
  int c = from_utf(ucode, tty->bold);
  if (c < 0) c = '?';
  cursor[0] = c & 0xff;
  cursor[1] = tty->style | (8 & ~(c >> 5));
  tty->cursor += 2;
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
  //printf("[textwm] CSI: %s\n", tty->csi);
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
  int cpos = ((tty->cursor - tty->frame_start) & 0xffff) >> 1;
  int col = cpos & 0xff;
  int line = cpos >> 8;
  int n = 1, m = 1;
  switch (tty->csi[tty->csi_len - 1]) {
    case 'F':
      col = 0;
    case 'A':
      sscanf(tty->csi, "%d", &n);
      line -= n;
      break;
    case 'E':
      col = 0;
    case 'B':
      sscanf(tty->csi, "%d", &n);
      line += n;
      break;
    case 'b': {
      sscanf(tty->csi, "%d", &n);
      m = (unsigned)(tty->style | 8) << 8;
      int to = (tty->cursor + (n<<1)) & 0xffff;
      for (int i = tty->cursor; i != to; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      col += n;
      break;
    }
    case 'P': {
      sscanf(tty->csi, "%d", &n);
      //m = (unsigned)(tty->style | 8) << 8;
      int line_end = (tty->cursor + 512) & ~511;
      n <<= 1;
      if (tty->cursor + n > line_end) n = line_end - tty->cursor;
      for (int i = tty->cursor; i < line_end - n; ++i) tty->frame[i] = tty->frame[i + n];
      //int to = (tty->cursor + (n<<1)) & 0xffff;
      //for (int i = tty->cursor; i != to; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      break;
    }
    case 'C':
      sscanf(tty->csi, "%d", &n);
      col += n;
      break;
    case 'D':
      sscanf(tty->csi, "%d", &n);
      col -= n;
      break;
    case 'G':
      sscanf(tty->csi, "%d", &n);
      col = n - 1;
      break;
    case 'd':
      sscanf(tty->csi, "%d", &n);
      line = n - 1;
      break;
    case 'f':
    case 'H':
      if (tty->csi[0] == ';')
        sscanf(tty->csi, "%d", &m);
      else
        sscanf(tty->csi, "%d;%d", &n, &m);
      line = n - 1;
      col = m - 1;
      break;
    case 'm':
      tty_sgr(tty);
      break;
    case 'J':
      n = 0;
      sscanf(tty->csi, "%d", &n);
      m = (unsigned)(tty->style | 8) << 8;
      if (n == 0) {
        for (int i = tty->cursor; i != tty->frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      } else if (n == 1) {
        for (int i = tty->frame_start; i != tty->cursor; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      } else if (n == 2) {
        for (int i = tty->frame_start; i != tty->frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = m;
      }
      break;
    case 'K': {
      n = 0;
      sscanf(tty->csi, "%d", &n);
      int from = tty->cursor, to = tty->cursor;
      if (n == 0) {
        to = (tty->cursor + 0x200) & ~0x1ff;
      } else if (n == 1) {
        from = tty->cursor & ~0x1ff;
      } else if (n == 2) {
        from = tty->cursor & ~0x1ff;
        to = (tty->cursor + 0x200) & ~0x1ff;
      }
      unsigned v = (unsigned)(tty->style | 8) << 8;
      for (char* p = tty->frame + from; p != tty->frame + to; p += 2) *(short*)p = v;
      break;
    }
    case 'S':
      sscanf(tty->csi, "%d", &n);
      n = n << 9;
      tty->frame_start = (tty->frame_start - n) & 0xffff;
      tty->frame_end = (tty->frame_end - n) & 0xffff;
      update_taddr(tty_id);
      break;
    case 'T':
      sscanf(tty->csi, "%d", &n);
      n = n << 9;
      tty->frame_start = (tty->frame_start + n) & 0xffff;
      tty->frame_end = (tty->frame_end + n) & 0xffff;
      update_taddr(tty_id);
      break;
    default: goto err;
  }
  if (line < 0) line = 0;
  if (col < 0) col = 0;
  int rh = tty->workspace < 0 ? text_height : tty->height;
  int rw = tty->workspace < 0 ? text_width : tty->width;
  if (line >= rh) line = rh - 1;
  if (col >= rw) col = rw - 1;
  tty->cursor = (tty->frame_start + (line << 9) | (col << 1)) & 0xffff;
  return;
err:
  printf("[textwm] Can't process CSI: %s\n", tty->csi);
}

void tty_handler(int tty_id, char c) {
  struct TTY *tty = &ttys[tty_id];
  //printf("TTY%d %d frame_start=%d cursor=%d frame_end=%d\n", tty_id, c, tty->frame_start, tty->cursor, tty->frame_end);
  if (tty->state == 'e') {
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
    switch (c) {
      case 7: break; // beep
      case 0xc: tty->cursor = tty->frame_start; break;
      case 0x1b: tty->state = 'e'; break; // start escape
      case '\r': {
        //char* to = tty->frame + tty->frame_start + ((tty->cursor + 511) & ~511);
        //for (char* p = tty->frame + tty->frame_start + tty->cursor; p != to; p += 2) *(short*)p = (unsigned)tty->style << 8;
        tty->cursor &= ~511;
        break;
      }
      case '\n':
        tty->cursor += 512;
        break;
      case '\t':
        tty->cursor = (tty->cursor + 15) & ~15;
        break;
      case '\b':
        if (tty->cursor & 511) {
          tty->cursor -= 2;
          //char* p = tty->frame + tty->cursor;
          //p[0] = 0;
          //p[1] = tty->style;
        } else if (tty->cursor != tty->frame_start) {
          tty->cursor = tty->cursor - 512 + ((tty->width - 1) << 1);
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
  }
  tty->cursor &= 0xffff;
  if ((tty->cursor & ~511) == tty->frame_end) {
    int* line = (int*)(tty->frame + tty->cursor);
    int v = ((int)(tty->style|8) << 8) | ((int)(tty->style|8) << 24);
    for (int i = 0; i < 128; ++i) line[i] = v;
    tty->frame_start = (tty->frame_start + 512) & 0xffff;
    tty->frame_end = (tty->frame_end + 512) & 0xffff;
    update_taddr(tty_id);
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
