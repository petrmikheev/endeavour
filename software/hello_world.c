#include <endeavour_defs.h>
#include <endeavour_ext2.h>

void hello_line(const char* str) {
  bios_printf("\t\t");
  BIOS_TEXT_STYLE = 0x12;
  bios_printf("\t");
  bios_printf(str);
  bios_printf("\t\n");
  BIOS_TEXT_STYLE = BIOS_DEFAULT_TEXT_STYLE;
}

void register_char(char code, const char* data) {
  for (int i = 0; i < 4; ++i) {
    IO_PORT(VIDEO_REG_INDEX) = VIDEO_CHARMAP(code, i);
    IO_PORT(VIDEO_REG_VALUE) = ((int*)data)[i];
  }
}

const char c8[] = {0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
const char c9[] = {0x00, 0xe0, 0xf8, 0xfc, 0xfc, 0xfe, 0xfe, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
const char cA[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0x7f, 0x7f, 0x3f, 0x3f, 0x1f, 0x07, 0x00};
const char cB[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xfe, 0xfe, 0xfc, 0xfc, 0xf8, 0xe0, 0x00};

void load_wallpaper_bmp(char* dst) {
  init_ext2_reader(2048);
  struct Inode* inode = find_inode("/boot/wallpaper_1280x720.bmp");
  if (inode)
    read_file(inode, dst, inode->size_lo);
  else
    bios_printf("Wallpaper not found\n");
}

int main() {
  IO_PORT(VIDEO_CFG) = (IO_PORT(VIDEO_CFG) & ~3) | VIDEO_1280x720;
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_BG(1);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(40, 40, 20) | VIDEO_TEXT_ALPHA(48);
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(1);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(40, 40, 20) | VIDEO_TEXT_ALPHA(48);
  IO_PORT(VIDEO_REG_INDEX) = VIDEO_COLORMAP_FG(2);
  IO_PORT(VIDEO_REG_VALUE) = VIDEO_TEXT_COLOR(0, 255, 0) | VIDEO_TEXT_ALPHA(64);
  register_char(8, c8);
  register_char(9, c9);
  register_char(10, cA);
  register_char(11, cB);
  bios_printf("\n\n\n");
  hello_line("\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
  hello_line("  _   _\t  _ _\t\t __\t\t__\t\t _\t _ _ ");
  hello_line(" | | | | ___| | | ___\t\\ \\\t  / /__  _ __| | __| | |");
  hello_line(" | |_| |/ _ \\ | |/ _ \\\t\\ \\ /\\ / / _ \\| '__| |/ _` | |");
  hello_line(" |  _  |  __/ | | (_) |\t\\ V  V / (_) | |  | | (_| |_|");
  hello_line(" |_| |_|\\___|_|_|\\___( )\t\\_/\\_/ \\___/|_|  |_|\\__,_(_)");
  hello_line("\t\t\t\t\t |/\t\t\t\t\t\t\t\t ");
  hello_line("\t\t\t\t\t\t\t\t\t\t\t\t\t\t");
  short* text_pos = (short*)(BIOS_TEXT_BUFFER_ADDR + BIOS_CURSOR_POS);
  short* first_line = text_pos - 8 * 256 + 8;
  short* last_line  = text_pos - 1 * 256 + 8;
  first_line[0] = 0x0108;
  first_line[63] = 0x0109;
  last_line[0] = 0x010A;
  last_line[63] = 0x010B;
  bios_printf("\n\n\n");
  if (SDCARD_SECTOR_COUNT > 0) {
    char* frame_buffer  = (char*)RAM_ADDR + 0x100000;
    char* wallpaper_bmp = (char*)RAM_ADDR + 0x500000;
    load_wallpaper_bmp(wallpaper_bmp);
    IO_PORT(VIDEO_GRAPHIC_ADDR) = (long)frame_buffer;
    for (int j = 0; j < 720; ++j) {
      const char* src = wallpaper_bmp + 70 + (720-j-1) * (1280 * 2);
      char* dst = frame_buffer + j * (1024*4);
      for (int i = 0; i < 1280*2; ++i) dst[i] = src[i];
    }
    IO_PORT(VIDEO_CFG) |= VIDEO_GRAPHIC_ON;
  }
  return 0;
}
