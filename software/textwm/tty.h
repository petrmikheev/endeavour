#ifndef TEXTWM_TTY
#define TEXTWM_TTY

#include "textwm.h"

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
  char csi[CSI_MAX_LEN];
  int csi_len;
  //char in_fifo[IN_FIFO_SIZE];
  //int in_start, in_end;
};

#define TTY_COUNT 7

extern struct TTY ttys[TTY_COUNT];
extern int active_tty;

void tty_handler(int tty_id, char c);

void tty_set_active(int tty_id);

#endif // TEXTWM_TTY
