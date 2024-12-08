#include <endeavour_defs.h>

void beep(unsigned volume, int periods) {
  unsigned short data[8] = {0x800, 0xda8, 0xfff, 0xda8, 0x800, 0x257, 0x0, 0x257};
  for (int i = 0; i < periods; ++i) {
    while (IO_PORT(AUDIO_STREAM) < 8);
    for (int j = 0; j < 8; ++j) {
      unsigned v = (((unsigned)data[j] * volume) >> 8) & 0xfff;
      IO_PORT(AUDIO_STREAM) = v | (v << 16);
    }
  }
}

int main() {
  IO_PORT(AUDIO_CFG) = AUDIO_SAMPLE_RATE(2400) | AUDIO_VOLUME(3); // beep 300Hz
  beep(0, 90);
  beep(256, 90);
  //beep(0, 30);
  //beep(256, 90);

  beep(0, 90);
  beep(256, 300);

  /*int f0 = 330;
  int f4 = 415;
  int f5 = 440;
  int d = 4;
  int p = 1;
  IO_PORT(AUDIO_CFG) = AUDIO_NO_SLEEP;
  for (int i=0;i<1000000;++i);*/
  //beep(f5, 4, 0x00000000, d);
  /*beep(f5, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f0, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f5, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f0, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f5, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f4, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f4, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f4, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f0, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f4, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f0, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f4, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f5, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f5, 4, 0xffffffff, d);
  beep(f5, 4, 0x00000000, p);
  beep(f5, 4, 0xffffffff, d);
  IO_PORT(AUDIO_CFG) = 0;*/
}
