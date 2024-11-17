#include "input.h"

#include <stdio.h>
#include <unistd.h>
#include <linux/input.h>

#include "tty.h"

// `input_event` from <linux/input.h> has size 24 and doesn't match `input_event` in linux kernel (that has size 16).
// I haven't managed to configure everything correctly, so using a custom struct.
struct InputEvent {
  unsigned t1, t2;
  unsigned short type;
  unsigned short code;
  unsigned value;
};

#define EVENT_BUF_SIZE 32

static struct InputEvent in_events[EVENT_BUF_SIZE];
static int from = 0, to = 0;

static struct InputEvent* next_event(int fd) {
  if (from == to) {
    int rsize = read(fd, in_events, sizeof(struct InputEvent) * EVENT_BUF_SIZE);
    if (rsize == -1) return 0;
    if (rsize < 0 || (rsize&15) != 0) {
      printf("[textwm] Input error. rsize=%d\n", rsize);
      return 0;
    }
    from = 0;
    to = rsize >> 4;
  }
  return from < to ? &in_events[from++] : 0;
}

int shift = 0;
int alt = 0;
int ctrl = 0;

char* with_shift = "\0\e!A#$%^&*()_+\b\tQWERTYUIOP{}\r\0ASDFGHJKL:\"~\0|ZXCVBNM<>?";
char* without_shift = "\0\e1234567890-=\b\tqwertyuiop[]\r\0asdfghjkl;'`\0\\zxcvbnm,./";

int parse_input_events(int fd, char* buf, int max_size) {
  int res = 0;
  while (res < max_size - 3) {
    struct InputEvent* ev = next_event(fd);
    if (!ev) break;
    if (ev->type != EV_KEY) continue;
    if (ev->code == 42 || ev->code == 54) { // lshift or rshift
      shift = ev->value;
      continue;
    }
    if (ev->code == 56 || ev->code == 100) { // alt
      alt = ev->value;
      continue;
    }
    if (ev->code == 29 || ev->code == 97) { // ctrl
      ctrl = ev->value;
      continue;
    }
    if (alt) {
      if (ev->code >= 2 && ev->code < 2+TTY_COUNT) tty_set_active(ev->code - 2);
      continue;
    }
    if (ev->value == 0) continue;
    int c = 0;
    if (ev->code <= 53) {
      c = (shift ? with_shift : without_shift)[ev->code];
    } else if (ev->code == 57) c = ' ';
    else {
      switch (ev->code) {
        case 57: c = ' '; break;
        case 103: buf[res++] = '\e'; buf[res++] = '['; buf[res++] = 'A'; c = 0; break; // up
        case 105: buf[res++] = '\e'; buf[res++] = '['; buf[res++] = 'D'; c = 0; break; // left
        case 106: buf[res++] = '\e'; buf[res++] = '['; buf[res++] = 'C'; c = 0; break; // right
        case 108: buf[res++] = '\e'; buf[res++] = '['; buf[res++] = 'B'; c = 0; break; // down
        case 111: buf[res++] = '\e'; buf[res++] = '['; buf[res++] = 'C'; c = '\b'; break; // del
        // f1-f10  59-68
        // f11   87
        // f12   88
        default: printf("[textwm] keypress %d\n", ev->code);
      }
    }
    if (ctrl && c >= 'a' && c <= 'z') c -= ('a' - 1);
    if (c) buf[res++] = c;
  }
  return res;
}
