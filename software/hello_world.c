#include <endeavour_defs.h>

void hello_line(const char* str) {
  bios_printf("\t\t");
  BIOS_TEXT_STYLE = 0x12;
  bios_printf("    ");
  bios_printf(str);
  bios_printf("    \n");
  BIOS_TEXT_STYLE = BIOS_DEFAULT_TEXT_STYLE;
}

void register_char(char code, const char* data) {
  for (int i = 0; i < 4; ++i) {
    IO_PORT(VIDEO_REG_INDEX) = VIDEO_CHARMAP(code, i);
    IO_PORT(VIDEO_REG_VALUE) = ((int*)data)[i];
  }
}

char c8[] = {0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
char c9[] = {0x00, 0xe0, 0xf8, 0xfc, 0xfc, 0xfe, 0xfe, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
char cA[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0x7f, 0x7f, 0x3f, 0x3f, 0x1f, 0x07, 0x00};
char cB[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xfe, 0xfe, 0xfc, 0xfc, 0xf8, 0xe0, 0x00};

int main() {
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_BG(1);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(40, 40, 20) | VIDEO_TEXT_ALPHA(8);
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(1);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(40, 40, 20) | VIDEO_TEXT_ALPHA(8);
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(2);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(0, 255, 0) | VIDEO_TEXT_ALPHA(15);
  register_char(8, c8);
  register_char(9, c9);
  register_char(10, cA);
  register_char(11, cB);
  bios_printf("\n\n\n");
  hello_line("                                                        ");
  hello_line("  _   _      _ _         __        __         _     _ _ ");
  hello_line(" | | | | ___| | | ___    \\ \\      / /__  _ __| | __| | |");
  hello_line(" | |_| |/ _ \\ | |/ _ \\    \\ \\ /\\ / / _ \\| '__| |/ _` | |");
  hello_line(" |  _  |  __/ | | (_) |    \\ V  V / (_) | |  | | (_| |_|");
  hello_line(" |_| |_|\\___|_|_|\\___( )    \\_/\\_/ \\___/|_|  |_|\\__,_(_)");
  hello_line("                     |/                                 ");
  hello_line("                                                        ");
  short* first_line = (short*)(BIOS_CURSOR_ADDR - 8 * 512) + 8;
  short* last_line = (short*)(BIOS_CURSOR_ADDR - 1 * 512) + 8;
  first_line[0] = 0x0108;
  first_line[63] = 0x0109;
  last_line[0] = 0x010A;
  last_line[63] = 0x010B;
  bios_printf("\n\n\n");
  return 0;
}
