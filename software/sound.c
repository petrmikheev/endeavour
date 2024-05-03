#include <endeavour_defs.h>

int main() {
  IO_PORT(AUDIO_CFG) = AUDIO_FLUSH | AUDIO_VOLUME(AUDIO_MAX_VOLUME) | AUDIO_SAMPLE_RATE(/*44100*/ 6000);
  for (int j=0; j<1000000; ++j) {
    unsigned audio_buf_size = IO_PORT(AUDIO_STREAM);
    for (int i = 0; i < audio_buf_size / 2; ++i) {
      IO_PORT(AUDIO_STREAM) = -32768;
      IO_PORT(AUDIO_STREAM) = 32767;
    }
  }
  return 0;
}
