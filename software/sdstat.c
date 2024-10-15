#include <endeavour_defs.h>

static const unsigned
    // Command bit enumerations
    SDIO_CMD      = 0x00000040,
    SDIO_R1       = 0x00000100,
    SDIO_R2       = 0x00000200,
    SDIO_R1b      = 0x00000300,
    SDIO_WRITE    = 0x00000400,
    SDIO_MEM      = 0x00000800,
    SDIO_FIFO     = 0x00001000,
    SDIO_ERR      = 0x00008000,
    SDIO_REMOVED  = 0x00040000,
    SDIO_PRESENTN = 0x00080000,
    SDIO_BUSY     = 0x00104800,
    // PHY enumerations
    SDIO_W4       = 0x00000400,
    SDIO_PUSHPULL = 0x00003000,
    SDIOCK_25MHZ  = 0x00000003,
    SDIOCK_50MHZ  = 0x00000002,
    SDIOCK_100MHZ = 0x00000001,
    SECTOR_512B   = 0x09000000;

#define BASE_CLK_IS_48MHZ

static const unsigned
#ifdef BASE_CLK_IS_48MHZ
  SDIOCK_DEFAULT = SDIOCK_50MHZ,  // It is actually 24 MHz
  SDIOCK_HS = SDIOCK_100MHZ;  // It is actually 48 MHz
#else
  SDIOCK_DEFAULT = SDIOCK_25MHZ,
  SDIOCK_HS = SDIOCK_50MHZ;
#endif

static unsigned command(unsigned cmd, unsigned arg) {
  IO_PORT(SDCARD_DATA) = arg;
  IO_PORT(SDCARD_CMD) = SDIO_CMD | SDIO_ERR | cmd;
  while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);
  return IO_PORT(SDCARD_DATA);
}

unsigned init_sdcard() {
  bios_printf("SD card: ");

  if (IO_PORT(SDCARD_CMD) & SDIO_PRESENTN) {
    bios_printf("slot empty\n");
    return 0;
  }

  IO_PORT(SDCARD_PHY) = SDIOCK_DEFAULT | SECTOR_512B | SDIO_PUSHPULL;
  while (SDIOCK_DEFAULT != (IO_PORT(SDCARD_PHY) & 0xff));

  // CMD0 - reset
  command(SDIO_REMOVED, 0);

  // CMD8 - check power range
  if ((command(SDIO_R1 | 8, 0x1a5) & 0xff) != 0xa5 || (IO_PORT(SDCARD_CMD) & SDIO_ERR)) {
    bios_printf("no response\n");
    return 0;
  }

  // ACMD41
  while(1) {
    command(SDIO_R1 | 55, 0);
    unsigned ocr = command(SDIO_R1+41, 0x50ff8000);
    if ((IO_PORT(SDCARD_CMD) & 0x38000) == 0x8000) {
      bios_printf("initialization failed\n");
      return 0;
    }
    if (ocr & 0x80000000) break;
  }

  // CMD2 - read CID
  command(SDIO_R2 | 2, 0);
  unsigned CID[4] = {IO_PORT(SDCARD_FIFO0), IO_PORT(SDCARD_FIFO0),
                     IO_PORT(SDCARD_FIFO0), IO_PORT(SDCARD_FIFO0)};
  char product[6] = {CID[0], CID[1]>>24, CID[1]>>16, CID[1]>>8, CID[1], 0};
  bios_printf(product);

  // CMD3 - read RCA
  unsigned rca = command(SDIO_R1 | 3, 0) & 0xffff0000;

#ifndef SIMULATION
  // CMD9 - read CSD
  command(SDIO_R2 | 9, rca);
  unsigned CSD[4] = {IO_PORT(SDCARD_FIFO0), IO_PORT(SDCARD_FIFO0),
                    IO_PORT(SDCARD_FIFO0), IO_PORT(SDCARD_FIFO0)};
  int csd_type = (CSD[0] >> 30) & 3;
  if (csd_type != 1) {
    bios_printf(" (CSD type %d, not supported)\n", csd_type);
    return 0;
  }
  unsigned csize = ((CSD[1] & 0x3f) << 16) | (CSD[2] >> 16);
  unsigned sector_count = (csize + 1) * 1024;
#else
  // Simulation model doesn't implement CSD
  unsigned sector_count = 2048;
#endif
  bios_printf(" %uMB\n", sector_count / 2048);

  // CMD7 - select card
  command(SDIO_R1b | 7, rca);

  // ACMD6 - set 4bit bus mode
  command(SDIO_R1 | 55, rca);
  command(SDIO_R1 | 6, 0x2);
  unsigned phy = IO_PORT(SDCARD_PHY) | SDIO_W4;

  // CMD6 - check if HS mode (50MHz) is available
  phy = (phy & 0xf0ffffff) | (6<<24);  // 64 byte response
  IO_PORT(SDCARD_PHY) = phy;

#ifndef SIMULATION
  command(SDIO_R1 | SDIO_MEM | 6, 0x00fffff1);
  (void)IO_PORT(SDCARD_FIFO0);
  (void)IO_PORT(SDCARD_FIFO0);
  (void)IO_PORT(SDCARD_FIFO0);
  int hs = (IO_PORT(SDCARD_FIFO0) & 0x020000) && !(IO_PORT(SDCARD_CMD) & SDIO_ERR);

  if (hs) {  // CMD6 - switch to HS mode
    command(SDIO_R1 | SDIO_MEM | 6, 0x80fffff1);
    phy = (phy & ~0xff) | SDIOCK_HS;
  }
#else
  // Simulation model doesn't implement CMD6
  phy = (phy & ~0xff) | SDIOCK_HS;
#endif

  phy = (phy & 0xf0ffffff) | SECTOR_512B;

  IO_PORT(SDCARD_PHY) = phy;
  while ((phy & 0xff) != (IO_PORT(SDCARD_PHY) & 0xff));

  return rca;
}

int main() {
  bios_printf("sdstat\n");

  char* data = (char*)0x80400000;
  for (int i = 0; i < 200; ++i) {
    bios_printf("b%d-%d\n", i<<4, (i<<4) + 15);
    if (bios_sdwrite(data, i<<4, 16) != 16) bios_printf("ERROR\n");
  }

  /*unsigned rca = init_sdcard();
  //unsigned rca = 0;//command(SDIO_R1 | 3, 0) & 0xffff0000;
  //command(SDIO_R1b | 7, rca);
  //if (IO_PORT(SDCARD_CMD) & SDIO_ERR) bios_printf("ERROR CMD=%8x\n", IO_PORT(SDCARD_CMD));
  bios_printf("rca = %8x\n", rca);

  char* data = (char*)0x80400000;
  for (int i = 0; i < 512; ++i) data[i] = i;
  for (int i = 0; i < 1000; ++i) {
    bios_printf("b%d\n", i);
    bios_sdwrite(data, i, 1);
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) bios_printf("ERROR CMD=%8x\n", IO_PORT(SDCARD_CMD));
    unsigned cstatus;
    int counter = 0;
    do {
      cstatus = command(SDIO_R1 | 13, rca);
      if (++counter > 10000000) {
        bios_printf("Oops\n");
        return 1;
      }
    } while (!(cstatus & (1<<8)));
  }*/
  bios_printf("r\n");
  bios_sdread(data, 123, 1);
  if (IO_PORT(SDCARD_CMD) & SDIO_ERR) bios_printf("ERROR CMD=%8x\n", IO_PORT(SDCARD_CMD));

  bios_printf("end\n");
  return 0;
}