#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/poll.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <asm/termbits.h>
#include <string.h>

typedef char bool;
#define false 0
#define true 1

#define TTY_COUNT 7

int cfg_fd;
int display_fd;
char* display_data;

int display_cfg = -1;
int display_width, display_height;
int font_width, font_height;
int text_width, text_height;

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
  bool bold;
  char state;
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
    tty->style = 0xf;
    tty->bold = false;
    //tty->in_start = tty->in_end = 0;
    pfds[i + 2].fd = tty->fd;
    pfds[i + 2].events = POLLIN;
  }
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

#define ACTIVE_WINDOW_BG 0
#define WINDOW_BG 1
#define SCREEN_BG 2

void command(const char* cmd) {
  unsigned i, color, alpha;
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
  } else goto err;
  return;
err:
  printf("[textwm] Invalid command: %s\n", cmd);
}

/*void input_handler(char c) {
  printf("IN %d '%c'\n", c, c);
}*/

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

void tty_print(struct TTY *tty, unsigned code) {
  char* cursor = tty->frame + tty->cursor;
  cursor[0] = code >= 0x80 ? '?' : code;
  cursor[1] = tty->style | 8;
  tty->cursor += 2;
}

void tty_sgr(struct TTY *tty) {
  tty->style = 0xf;
  tty->bold = false;
  int i = 0;
  const char* s = tty->csi;
  while (*s >= '0' && *s <= '9') {
    int c = 0;
    while (*s >= '0' && *s <= '9') c = c * 10 + *s++ - '0';
    if (*s == ';') s++;
    if (c == 1 || c == 4) tty->bold = true;
    else if (c >= 30 && c <= 37) tty->style = (tty->style & 0xf0) | (c - 30);
    else if (c >= 40 && c <= 47) tty->style |= ((c - 40) << 4) | 0x80;
  }
}

void update_taddr(int tty_id) {
  struct TTY *tty = &ttys[tty_id];
  if (tty_id == active_tty && tty->workspace < 0) {
    int taddr = tty->frame - display_data + tty->frame_start;
    ioctl(display_fd, IOCTL_SET_TEXT_ADDR, &taddr);
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
      if (n == 0) {
        for (int i = tty->cursor; i != tty->frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = (unsigned)tty->style << 8;
      } else if (n == 1) {
        for (int i = tty->frame_start; i != tty->cursor; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = (unsigned)tty->style << 8;
      } else if (n == 2) {
        for (int i = tty->frame_start; i != tty->frame_end; i = (i + 2) & 0xffff) *(short*)(tty->frame + i) = (unsigned)tty->style << 8;
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
      unsigned v = (unsigned)tty->style << 8;
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
  if (line >= tty->height) line = tty->height - 1;
  if (col >= tty->width) col = tty->width - 1;
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
    if (c == '[')
      tty->state = '['; // CSI
    else
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
    int v = ((int)tty->style << 8) | ((int)tty->style << 24);
    for (int i = 0; i < 128; ++i) line[i] = v;
    tty->frame_start = (tty->frame_start + 512) & 0xffff;
    tty->frame_end = (tty->frame_end + 512) & 0xffff;
    update_taddr(tty_id);
  }
}

int main() {
  printf("textwm started\n");
  display_fd = open("/dev/display", O_RDWR);
  display_data = mmap(0, 0x400000,  PROT_READ | PROT_WRITE, MAP_SHARED, display_fd, (off_t)0);
  ioctl(display_fd, IOCTL_DISABLE_SBI_CONSOLE, &display_fd);

  const char* cfg_name = "/dev/textwmcfg";
  mkfifo(cfg_name, 0666);
  cfg_fd = open(cfg_name, O_RDONLY | O_NONBLOCK);

  pfds[0].fd = STDIN_FILENO;
  pfds[0].events = POLLIN;
  pfds[1].fd = cfg_fd;
  pfds[1].events = POLLIN;

  read_display_cfg();
  printf("text width=%d height=%d\n", text_width, text_height);
  init_ttys();

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
    }
    if (pfds[1].revents & POLLIN) {
      rsize = read(pfds[1].fd, buf, BUF_SIZE);
      for (int j = 0; j < rsize; ++j) cfg_handler(buf[j]);
    }
    for (int i = 0; i < TTY_COUNT; ++i) {
      if (pfds[i + 2].revents & POLLIN) {
        rsize = read(pfds[i + 2].fd, buf, BUF_SIZE);
        for (int j = 0; j < rsize; ++j) tty_handler(i, buf[j]);
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
