#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/poll.h>
#include <sys/ioctl.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <asm/termbits.h>
#include <string.h>

typedef char bool;
#define false 0
#define true 1

int utf_extra[] = {
  0xC4, 0xD6, 0xDC, 0xDF,
  0xE4, 0xF6, 0xFC, 0x1EDE,
  0x401, 0x451,
  0x2500, 0x2502, 0x250C, 0x2510,
  0x2514, 0x2518, 0x251C, 0x2524,
  0x252C, 0x2534, 0x253C, 0x2550,
  0x2551, 0x2552, 0x2553, 0x2554,
  0x2555, 0x2556, 0x2557, 0x2558,
  0x2559, 0x255A, 0x255B, 0x255C,
  0x255D, 0x255E, 0x255F, 0x2560,
  0x2561, 0x2562, 0x2563, 0x2564,
  0x2565, 0x2566, 0x2567, 0x2568,
  0x2569, 0x256A, 0x256B, 0x256C,
  0x2580, 0x2584, 0x2588, 0x258C,
  0x2590, 0x2591, 0x2592, 0x2593};

#define UTF_EXTRA_BOLD_SIZE 8
#define UTF_EXTRA_SIZE (sizeof(utf_extra) / sizeof(int))

int from_utf(unsigned u, bool bold) {
  if (bold && u >= 0x21 && u <= 0x7E) return u - 0x21 + 0x7F;
  if (u <= 0x7E) return u;
  if (u >= 0x410 && u <= 0x44F) return u - 0x410 + 0xDD;
  for (int i = 0; i < UTF_EXTRA_SIZE; ++i) {
    if (utf_extra[i] == u) {
      if (bold && i < UTF_EXTRA_BOLD_SIZE)
        return 0x11D + UTF_EXTRA_SIZE + i;
      else
        return 0x11D + i;
    }
  }
  return -1;
}

int to_utf(unsigned v) {
  if (v <= 0x7E) return v;
  if (v >= 0x7F && v <= 0xDC) return v - 0x7F + 0x21;
  if (v >= 0xDD && v <= 0x11C) return v - 0xDD + 0x410;
  if (v >= 0x11D && v < 0x11D + UTF_EXTRA_SIZE) return utf_extra[v - 0x11D];
  if (v >= 0x11D + UTF_EXTRA_SIZE && v < 0x11D + UTF_EXTRA_SIZE + UTF_EXTRA_BOLD_SIZE) return utf_extra[v - 0x11D - UTF_EXTRA_SIZE];
  // Available: 0x15F - 0x1FF
  return -1;
}

#define TTY_COUNT 7

int cfg_fd;
int display_fd;
char* display_data;

int display_cfg = -1;
int display_width, display_height;
int font_width, font_height;
int text_width, text_height;

int winstyle = 0;

#define IOCTL_GET_TEXT_ADDR 0xaa0
#define IOCTL_GET_GRAPHIC_ADDR 0xaa1
#define IOCTL_SET_TEXT_ADDR 0xaa2
#define IOCTL_SET_GRAPHIC_ADDR 0xaa3
#define IOCTL_GET_CFG 0xaa4
#define IOCTL_SET_CFG 0xaa5
#define IOCTL_SET_CHARMAP 0xaa6
#define IOCTL_DISABLE_SBI_CONSOLE 0xaa7

#define VIDEO_640x480     1
#define VIDEO_1024x768    2
#define VIDEO_1280x720    3
#define VIDEO_TEXT_ON     4
#define VIDEO_GRAPHIC_ON  8
#define VIDEO_FONT_HEIGHT(X) ((((X)-1)&15) << 4) // allowed range [6, 16]
#define VIDEO_FONT_WIDTH(X) ((((X)-1)&7) << 8)   // allowed range [6, 8]
#define VIDEO_RGB565      0
#define VIDEO_RGAB5515    0x800

bool read_display_cfg() {
  int dcfg;
  ioctl(display_fd, IOCTL_GET_CFG, &dcfg);
  if (dcfg == display_cfg) return false;
  display_cfg = dcfg;
  switch (dcfg & 3) {
    case 0:
    case 1:
      display_width = 640;
      display_height = 480;
      break;
    case 2:
      display_width = 1024;
      display_height = 768;
      break;
    case 3:
      display_width = 1280;
      display_height = 720;
      break;
  }
  font_height = ((dcfg >> 4) & 15) + 1;
  font_width = ((dcfg >> 8) & 7) + 1;
  if (font_height < 6) font_height = 6;
  if (font_width < 6) font_width = 6;
  text_width = (display_width + font_width - 1) / font_width;
  text_height = (display_height + font_height - 1) / font_height;
  return true;
}

//#define IN_FIFO_SIZE 128
#define CSI_MAX_LEN 32

struct TTY {
  int fd;
  char* frame;
  int frame_start, frame_end;
  int cursor;
  int width, height;
  int window_posx, window_posy;
  int workspace;
  char style;
  char style_at_cursor;
  char state;
  bool cursor_visible;
  bool cursor_blink;
  bool bold;
  unsigned ucode, ucount;
  char csi[32];
  int csi_len;
  //char in_fifo[IN_FIFO_SIZE];
  //int in_start, in_end;
};

struct TTY ttys[TTY_COUNT];
int active_tty = 0;

struct pollfd pfds[TTY_COUNT + 2];

void init_ttys() {
  struct winsize ws;
  ws.ws_col = text_width;
  ws.ws_row = text_height;
  for (int i = 0; i < TTY_COUNT; ++i) {
    struct TTY *tty = &ttys[i];
    char path[64];
    snprintf(path, 64, "/dev/ptyp%d", i);
    tty->fd = open(path, O_RDWR);
    ioctl(tty->fd, TIOCSWINSZ, &ws);
    tty->frame = display_data + (i << 16);
    tty->width = text_width;
    tty->height = text_height;
    tty->state = 0;
    if (i == 0) {
      int v;
      ioctl(display_fd, IOCTL_GET_TEXT_ADDR, &v);
      tty->frame_start = v & 0xffff;
      tty->cursor = (tty->frame_start + (tty->height << 9) - 512) & 0xffff;
    } else {
      tty->frame_start = tty->cursor = 0;
    }
    tty->frame_end = (tty->frame_start + (tty->height << 9)) & 0xffff;
    tty->window_posx = tty->window_posy = 0;
    tty->workspace = -1;
    tty->style = 0x7;
    tty->style_at_cursor = 0x7;
    tty->bold = false;
    tty->cursor_visible = false;
    tty->cursor_blink = false;
    //tty->in_start = tty->in_end = 0;
    pfds[i + 2].fd = tty->fd;
    pfds[i + 2].events = POLLIN;
  }
}

char swap_fg_bg(char style) {
  int bg = 8 | (style & 7);
  int fg = (style & 0x80) ? ((style >> 4) & 7) : 0;
  return (style & 8) | fg | (bg << 4);
}

void hide_cursor(struct TTY *tty) {
  if (!tty->cursor_visible) return;
  tty->frame[tty->cursor + 1] = tty->style_at_cursor;
  tty->cursor_visible = false;
}

void show_cursor(struct TTY *tty) {
  if (tty->cursor_visible) return;
  tty->style_at_cursor = tty->frame[tty->cursor + 1];
  tty->frame[tty->cursor + 1] = swap_fg_bg(tty->style_at_cursor);
  tty->cursor_visible = true;
}

void set_charmap(unsigned i, unsigned value) {
  struct {
    unsigned index;
    unsigned value;
  } cd = {i, value};
  ioctl(display_fd, IOCTL_SET_CHARMAP, &cd);
}

void set_wallpaper(const char* arg) {
  int dcfg;
  ioctl(display_fd, IOCTL_GET_CFG, &dcfg);
  if (*arg == 0 || strcmp(arg, "off") == 0) {
    printf("[textwm] Wallpaper off\n");
    dcfg &= ~VIDEO_GRAPHIC_ON;
  } else {
    printf("[textwm] Wallpaper \"%s\"\n", arg);
    FILE* f = fopen(arg, "rb");
    if (!f) {
      printf("[textwm] Can't open file\n");
      return;
    }
    for (int j = 0; j < 720; ++j) {
      fseek(f, 70 + (720-j-1) * (1280 * 2), SEEK_SET);
      char* dst = display_data + 0x100000 + j * (1024*4);
      fread(dst, 2, 1280, f);
    }
    fclose(f);
    unsigned gaddr = 0x100000;
    ioctl(display_fd, IOCTL_SET_GRAPHIC_ADDR, &gaddr);
    dcfg |= VIDEO_GRAPHIC_ON;
  }
  ioctl(display_fd, IOCTL_SET_CFG, &dcfg);
}

void update_taddr(int tty_id) {
  struct TTY *tty = &ttys[tty_id];
  if (tty_id == active_tty && tty->workspace < 0) {
    int taddr = tty->frame - display_data + tty->frame_start;
    ioctl(display_fd, IOCTL_SET_TEXT_ADDR, &taddr);
  }
}

void resize_tty(int tty_id) {
  struct TTY *tty = &ttys[tty_id];
  int prev_height = ((tty->frame_end - tty->frame_start) & 0xffff) >> 9;
  int new_height = tty->workspace < 0 ? text_height : tty->height;
  int cpos = ((tty->cursor - tty->frame_start) & 0xffff) >> 1;
  int col = cpos & 0xff;
  int line = cpos >> 8;
  int fill = 0x0f000f00;
  if (line >= prev_height - 1 || line >= new_height - 1) {
    line = new_height - 1;
    tty->frame_start = (tty->frame_end - (new_height << 9)) & 0xffff;
    for (int i = 0; i < new_height - prev_height; ++i) {
      int* lp = (int*)(tty->frame + ((tty->frame_start + (i<<9)) & 0xffff));
      for (int j = 0; j < 128; ++j) lp[j] = fill;
    }
  } else {
    tty->frame_end = (tty->frame_start + (new_height << 9)) & 0xffff;
    for (int i = prev_height; i < new_height; ++i) {
      int* lp = (int*)(tty->frame + ((tty->frame_start + (i<<9)) & 0xffff));
      for (int j = 0; j < 128; ++j) lp[j] = fill;
    }
  }
  struct winsize ws;
  ws.ws_row = new_height;
  ws.ws_col = tty->workspace < 0 ? text_width : tty->width;
  if (col >= ws.ws_col) col = ws.ws_col - 1;
  tty->cursor = (tty->frame_start + (line << 9) + (col << 1)) & 0xffff;
  ioctl(tty->fd, TIOCSWINSZ, &ws);
  update_taddr(tty_id);
}

void display_cfg_changed() {
  read_display_cfg();
  for (int i = 0; i < TTY_COUNT; ++i) {
    struct TTY *tty = &ttys[i];
    if (tty->workspace < 0) resize_tty(i);
  }
}

void set_font(const char* arg, bool bold) {
  if (bold)
    printf("[textwm] Loading font-bold \"%s\"\n", arg);
  else
    printf("[textwm] Loading font \"%s\"\n", arg);
  FILE* f = fopen(arg, "r");
  if (!f) {
    printf("[textwm] Can't open file\n");
    return;
  }
  char line[120];
  int cwidth = 0, cheight = 0;
  int ucode = 0;
  char cdata[16];
  int ci = -1;
  while (!feof(f)) {
    fgets(line, 119, f);
    if (strncmp(line, "ENCODING ", 9) == 0) {
      sscanf(line, "ENCODING %d", &ucode);
    } else if (strncmp(line, "BBX ", 4) == 0 && cwidth == 0) {
      sscanf(line, "BBX %d %d", &cwidth, &cheight);
      printf("[textwm] font width=%d height=%d\n", cwidth, cheight);
    } else if (strncmp(line, "BITMAP", 6) == 0) {
      ci = 0;
    } else if (strncmp(line, "ENDCHAR", 7) == 0) {
      int code = from_utf(ucode, bold);
      if (code < 32) continue;
      if (bold && code == from_utf(ucode, false)) continue;
      const unsigned* bitmap = (const unsigned*)cdata;
      //printf("u=%d c=%d bitmap: %08X %08X %08X %08X\n", ucode, code, bitmap[0], bitmap[1], bitmap[2], bitmap[3]);
      set_charmap(code * 4, bitmap[0]);
      set_charmap(code * 4 + 1, bitmap[1]);
      set_charmap(code * 4 + 2, bitmap[2]);
      set_charmap(code * 4 + 3, bitmap[3]);
      ci = -1;
    } else if (ci >= 0) {
      unsigned v;
      sscanf(line, "%x", &v);
      cdata[ci++ & 15] = v;
    }
  }
  fclose(f);
  if (!bold && cwidth && cheight && (cwidth != font_width || cheight != font_height)) {
    int dcfg;
    ioctl(display_fd, IOCTL_GET_CFG, &dcfg);
    dcfg = (dcfg & ~0x7f0) | ((cwidth-1) << 8) | ((cheight-1) << 4);
    ioctl(display_fd, IOCTL_SET_CFG, &dcfg);
    display_cfg_changed();
  }
}

void set_resolution(int w, int h) {
  int mode;
  if (w == 640 && h == 480) mode = 1;
  else if (w == 1024 && h == 768) mode = 2;
  else if (w == 1280 && h == 1024) mode = 3;
  else {
    printf("[textwm] Invalid resolution %dx%d. Supported: 640x480 / 1024x768 / 1280x720\n", w, h);
    return;
  }
  int dcfg;
  ioctl(display_fd, IOCTL_GET_CFG, &dcfg);
  dcfg = (dcfg & ~3) | mode;
  ioctl(display_fd, IOCTL_SET_CFG, &dcfg);
  display_cfg_changed();
}

#define ACTIVE_WINDOW_BG 0
#define WINDOW_BG 1
#define SCREEN_BG 2

void command(const char* cmd) {
  unsigned i = -1, color, alpha;
  if (strncmp(cmd, "fgcolor", 7) == 0) {
    if (sscanf(cmd, "fgcolor%d #%x %d", &i, &color, &alpha) != 3) goto err;
    set_charmap(16 + i, (color << 8) | alpha | 128);
    set_charmap(24 + i, (color << 8) | alpha);
  } else if (strncmp(cmd, "bgcolor", 7) == 0) {
    if (sscanf(cmd, "bgcolor%d #%x %d", &i, &color, &alpha) != 3) goto err;
    set_charmap(8 + i, (color << 8) | alpha);
  } else if (strncmp(cmd, "screen_color", 12) == 0) {
    if (sscanf(cmd, "screen_color #%x %d", &color, &alpha) != 2) goto err;
    set_charmap(SCREEN_BG, (color << 8) | alpha);
  } else if (strncmp(cmd, "window_color", 12) == 0) {
    if (sscanf(cmd, "window_color #%x %d", &color, &alpha) != 2) goto err;
    set_charmap(WINDOW_BG, (color << 8) | alpha);
  } else if (strncmp(cmd, "active_window_color", 19) == 0) {
    if (sscanf(cmd, "active_window_color #%x %d", &color, &alpha) != 2) goto err;
    set_charmap(ACTIVE_WINDOW_BG, (color << 8) | alpha);
  } else if (strncmp(cmd, "wallpaper ", 10) == 0) {
    const char* arg = cmd + 10;
    while (*arg == ' ') arg++;
    set_wallpaper(arg);
  } else if (strncmp(cmd, "font ", 5) == 0) {
    const char* arg = cmd + 5;
    while (*arg == ' ') arg++;
    set_font(arg, false);
  } else if (strncmp(cmd, "font-bold ", 10) == 0) {
    const char* arg = cmd + 10;
    while (*arg == ' ') arg++;
    set_font(arg, true);
  } else if (strncmp(cmd, "display ", 8) == 0) {
    int w, h;
    if (sscanf(cmd, "display %dx%d", &w, &h) != 2) goto err;
    set_resolution(w, h);
  } else if (strncmp(cmd, "window", 6) == 0) {
    int ws, x=-1, y=-1, w=-1, h=-1;
    int rcount = sscanf(cmd, "window%d ws=%d x=%d y=%d w=%d h=%d", &i, &ws, &x, &y, &w, &h);
    if (rcount < 2 || (rcount > 2 && rcount != 6) || i < 0 || i >= TTY_COUNT) goto err;
    struct TTY *tty = &ttys[i];
    tty->workspace = ws;
    if (rcount == 6) {
      tty->window_posx = x;
      tty->window_posy = y;
      tty->width = w;
      tty->height = h;
    }
    resize_tty(i);
  } else if (strncmp(cmd, "winstyle ", 9) == 0) {
    sscanf(cmd, "winstyle %d", &winstyle);
  } else if (strncmp(cmd, "active ", 7) == 0) {
    sscanf(cmd, "active %d", &i);
    if (i >= 0 && i < TTY_COUNT && i != active_tty) {
      active_tty = i;
      update_taddr(active_tty);
    }
  } else if (strcmp(cmd, "togglefull") == 0) {
    ttys[active_tty].workspace = ~ttys[active_tty].workspace;
    resize_tty(active_tty);
  } else goto err;
  return;
err:
  printf("[textwm] Invalid command: %s\n", cmd);
}

#define CMD_BUF_SIZE 160
char cmd_buf[CMD_BUF_SIZE];
int cmd_len = 0;

void cfg_handler(char c) {
  if (c == '\n' || cmd_len == CMD_BUF_SIZE - 1) {
    cmd_buf[cmd_len] = 0;
    if (cmd_buf[0] != 0 && cmd_buf[0] != '#') command(cmd_buf);
    cmd_len = 0;
  } else {
    cmd_buf[cmd_len++] = c;
  }
}

void tty_print(struct TTY *tty, unsigned ucode) {
  char* cursor = tty->frame + tty->cursor;
  int c = from_utf(ucode, tty->bold);
  if (c < 0) c = '?';
  cursor[0] = c & 0xff;
  cursor[1] = tty->style | (8 & ~(c >> 5));
  tty->cursor += 2;
}

void tty_sgr(struct TTY *tty) {
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

void tty_csi(int tty_id) {
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

void register_char(char code, const char* data) {
  set_charmap(code * 4, *(int*)data);
  set_charmap(code * 4 + 1, *(int*)(data + 4));
  set_charmap(code * 4 + 2, *(int*)(data + 8));
  set_charmap(code * 4 + 3, *(int*)(data + 12));
}

void init_special_chars() {
  static const char c8[] = {0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
  static const char c9[] = {0x00, 0xe0, 0xf8, 0xfc, 0xfc, 0xfe, 0xfe, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
  static const char cA[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0x7f, 0x7f, 0x3f, 0x3f, 0x1f, 0x07, 0x00};
  static const char cB[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xfe, 0xfe, 0xfc, 0xfc, 0xf8, 0xe0, 0x00};
  static const char cC[] = {0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x3f, 0x3f, 0x1f, 0x07, 0x00};
  static const char cD[] = {0x00, 0xe0, 0xf8, 0xfc, 0xfc, 0xfe, 0xfe, 0xfe, 0xfe, 0xfe, 0xfe, 0xfc, 0xfc, 0xf8, 0xe0, 0x00};
  register_char(0x8, c8);
  register_char(0x9, c9);
  register_char(0xA, cA);
  register_char(0xB, cB);
  register_char(0xC, cC);
  register_char(0xD, cD);
}

void hborder(int tty_id, char* buf, int y, bool top) {
  if (y < 0 || y >= text_height || winstyle == 0) return;
  buf += y << 9;
  struct TTY *tty = &ttys[tty_id];
  int bg = tty_id == active_tty ? 0x08 : 0x18;
  int fg = (winstyle >> 2) << 8;
  int l = tty->window_posx - 1;
  int r = tty->window_posx + tty->width;
  if (winstyle > 1) {
    ((unsigned short*)buf)[l] = (top ? 0x2808 : 0x280A) | fg;
    ((unsigned short*)buf)[l+1] = (tty_id == active_tty ? 0x080D : 0x180D) | fg;
    ((unsigned short*)buf)[r-1] = (tty_id == active_tty ? 0x080C : 0x180C) | fg;
    ((unsigned short*)buf)[r] = (top ? 0x2809 : 0x280B) | fg;
    l += 2;
    r -= 2;
  }
  if (l < 0) l = 0;
  if (r >= text_width) r = text_width - 1;
  for (int i = l; i <= r; ++i) buf[(i<<1) | 1] = bg;
}

void vborder(int tty_id, char* lbuf, int x, bool left) {
  if (x < 0 || x >= text_width || winstyle == 0) return;
  int bg = 0x88;
  if (winstyle & 1) {
    bg = tty_id == active_tty ? 0x08 : 0x18;
  }
  lbuf[(x << 1) | 1] = bg;
}

int blink_counter = 0;

void timer_handler(int sig, siginfo_t *si, void *uc) {
  //printf("timer %d\n");
  struct TTY *atty = &ttys[active_tty];
  if (atty->cursor_blink) {
    blink_counter = (blink_counter + 1) & 15;
    if (blink_counter >= 8)
      hide_cursor(atty);
    else
      show_cursor(atty);
  }
  int workspace = atty->workspace;
  if (workspace < 0) return;
  unsigned taddr;
  ioctl(display_fd, IOCTL_GET_TEXT_ADDR, &taddr);
  taddr = taddr == 0xf0000 ? 0xf8000 : 0xf0000;
  char* buf = display_data + taddr;
  int fill = 0x2f002f00;
  for (int* p = (int*)buf; p < (int*)(buf + 0x8000); ++p) *p = fill;
  for (int tty_id = 0; tty_id < TTY_COUNT; ++tty_id) {
    struct TTY *tty = &ttys[tty_id];
    if (tty->workspace != workspace) continue;
    hborder(tty_id, buf, tty->window_posy - 1, true);
    for (int y = 0; y < tty->height; ++y) {
      int ty = tty->window_posy + y;
      if (ty < 0 || ty >= text_height) continue;
      const char* src = tty->frame + ((tty->frame_start + (y << 9)) & 0xffff);
      char* dst = buf + (ty << 9);
      vborder(tty_id, dst, tty->window_posx - 1, true);
      for (int x = 0; x < tty->width; ++x) {
        int tx = tty->window_posx + x;
        if (tx < 0 || tx >= text_width) continue;
        unsigned short v = *(unsigned short*)(src + (x<<1));
        if (tty_id != active_tty && (v & 0xf000)==0) v |= 0x1000;
        *(unsigned short*)(dst + (tx<<1)) = v;
      }
      vborder(tty_id, dst, tty->window_posx + tty->width, false);
    }
    hborder(tty_id, buf, tty->window_posy + tty->height, false);
  }
  ioctl(display_fd, IOCTL_SET_TEXT_ADDR, &taddr);
}

void initialize_timer(void) {
  struct sigaction sa = { 0 };
  sa.sa_flags = SA_SIGINFO;
  sa.sa_sigaction = timer_handler;
  sigemptyset(&sa.sa_mask);
  sigaction(SIGRTMIN, &sa, NULL);

  struct itimerspec its = {
    .it_value.tv_sec  = 0,
    .it_value.tv_nsec = 100000000,
    .it_interval.tv_sec  = 0,
    .it_interval.tv_nsec = 100000000
  };

  struct sigevent sev = { 0 };
  sev.sigev_notify = SIGEV_SIGNAL;
  sev.sigev_signo = SIGRTMIN;

  timer_t timerId;
  timer_create(CLOCK_REALTIME, &sev, &timerId);
  timer_settime(timerId, 0, &its, NULL);
}

int main() {
  printf("textwm started\n");
  display_fd = open("/dev/display", O_RDWR);
  display_data = mmap(0, 0x400000,  PROT_READ | PROT_WRITE, MAP_SHARED, display_fd, (off_t)0);
  ioctl(display_fd, IOCTL_DISABLE_SBI_CONSOLE, &display_fd);
  init_special_chars();

  for (int i = 0x10000; i < 0x100000; i += 4) *(int*)(display_data + i) = 0x0f000f00;

  const char* cfg_name = "/dev/textwmcfg";
  mkfifo(cfg_name, 0666);
  cfg_fd = open(cfg_name, O_RDONLY | O_NONBLOCK);

  pfds[0].fd = STDIN_FILENO;
  pfds[0].events = POLLIN;
  pfds[1].fd = cfg_fd;
  pfds[1].events = POLLIN;

  read_display_cfg();
  printf("tty width=%d height=%d\n", text_width, text_height);
  init_ttys();

  initialize_timer();

#define BUF_SIZE 64
  char buf[BUF_SIZE];
  int rsize;
  while (true) {
    poll(pfds, TTY_COUNT + 2, -1);
    if (pfds[0].revents & POLLIN) {
      rsize = read(pfds[0].fd, buf, BUF_SIZE);
      // TODO catch ALT+id
      if (rsize) {
        if (write(ttys[active_tty].fd, buf, rsize) != rsize) {
          printf("Failed to write input to TTY\n");
        }
      }
      /*struct TTY *tty = &ttys[active_tty];
      for (int j = 0; j < rsize; ++j) {
        tty->in_fifo[tty->in_end++] = buf[j];
        if (tty->in_end == IN_FIFO_SIZE) tty->in_end = 0;
      }*/
      blink_counter = 0;
    }
    if (pfds[1].revents & POLLIN) {
      rsize = read(pfds[1].fd, buf, BUF_SIZE);
      for (int j = 0; j < rsize; ++j) cfg_handler(buf[j]);
    }
    for (int i = 0; i < TTY_COUNT; ++i) {
      if (pfds[i + 2].revents & POLLIN) {
        struct TTY *tty = &ttys[i];
        tty->cursor_blink = false;
        hide_cursor(tty);
        rsize = read(pfds[i + 2].fd, buf, BUF_SIZE);
        for (int j = 0; j < rsize; ++j) tty_handler(i, buf[j]);
        show_cursor(tty);
        tty->cursor_blink = true;
      }
      /*struct TTY *tty = &ttys[i];
      while (tty->in_start != tty->in_end) {
        if (write(tty->fd, &tty->in_fifo[tty->in_start], 1) == 1) {
          if (++tty->in_start == IN_FIFO_SIZE) tty->in_start = 0;
        } else
          break;
      }
      if (tty->in_start == tty->in_end)
        pfds[i + 2].events &= ~POLLOUT;
      else
        pfds[i + 2].events |= ~POLLOUT;*/
    }
  }
  return 0;
}
