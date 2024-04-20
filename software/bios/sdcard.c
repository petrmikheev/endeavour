// Minimalistic driver for sdspi (https://github.com/ZipCPU/sdspi) controller.
// Supports only SDHC and SDXC cards.

#include <endeavour_defs.h>

// Constants are copied from https://github.com/ZipCPU/sdspi/blob/master/sw/sdiodrv.c
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
    SDIO_BUSY     = 0x00104800,
    // PHY enumerations
    SDIO_W4       = 0x00000400,
    SDIO_PUSHPULL = 0x00003000,
    SDIOCK_25MHZ  = 0x00000003,
    SDIOCK_50MHZ  = 0x00000002,
    SECTOR_512B   = 0x09000000;

static unsigned command(unsigned cmd, unsigned arg) {
  IO_PORT(SDCARD_DATA) = arg;
  IO_PORT(SDCARD_CMD) = SDIO_CMD | SDIO_ERR | cmd;
  while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);
  return IO_PORT(SDCARD_DATA);
}

unsigned init_sdcard() {
  bios_printf("SD card: ");
  IO_PORT(SDCARD_PHY) = SDIOCK_25MHZ | SECTOR_512B | SDIO_PUSHPULL;
  while (SDIOCK_25MHZ != (IO_PORT(SDCARD_PHY) & 0xff));

  // CMD0 - reset
  command(SDIO_REMOVED, 0);

  // CMD8 - check power range
  if ((command(SDIO_R1 | 8, 0x1a5) & 0xff) != 0xa5 || (IO_PORT(SDCARD_CMD) & SDIO_ERR)) {
    bios_printf("no card\n");
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
    phy = (phy & ~0xff) | SDIOCK_50MHZ;
  }
#else
  // Simulation model doesn't implement CMD6
  phy = (phy & ~0xff) | SDIOCK_50MHZ;
#endif

  phy = (phy & 0xf0ffffff) | SECTOR_512B;

  IO_PORT(SDCARD_PHY) = phy;
  while ((phy & 0xff) != (IO_PORT(SDCARD_PHY) & 0xff));

  return sector_count;
}

/* Simplified implementation (a bit slower)
unsigned sdread_impl(unsigned* dst, unsigned sector, unsigned sector_count) {
  for (unsigned i = 0; i < sector_count; ++i) {
    command(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17, sector++);
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) return i;
    for (int i = 0; i < 128; ++i) *dst++ = IO_PORT(SDCARD_FIFO0_LE);
  }
  return sector_count;
}*/

static unsigned* receive_sector(unsigned* ptr, long port) {
  unsigned* end = ptr + 128;
  while (ptr < end) {
    /*ptr[0] = IO_PORT(port);
    ptr[1] = IO_PORT(port);
    ptr[2] = IO_PORT(port);
    ptr[3] = IO_PORT(port);
    ptr += 4;*/
    *ptr++ = IO_PORT(port);
  }
  return ptr;
}

unsigned sdread_impl(unsigned* dst, unsigned sector, unsigned sector_count) {
  if (sector_count == 0) return 0;
  command(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17, sector);
  unsigned fifo = SDIO_FIFO;
  unsigned cmd;
  for (unsigned b = 0; b < sector_count - 1; ++b) {
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) {
      return b;
    }
    IO_PORT(SDCARD_DATA) = ++sector;
    IO_PORT(SDCARD_CMD) = (SDIO_CMD | SDIO_R1 | SDIO_MEM | 17) | fifo;
    dst = receive_sector(dst, fifo ? SDCARD_FIFO0_LE : SDCARD_FIFO1_LE);
    while ((cmd=IO_PORT(SDCARD_CMD)) & SDIO_BUSY);
    fifo ^= SDIO_FIFO;
  }
  if (IO_PORT(SDCARD_CMD) & SDIO_ERR) return sector_count - 1;
  receive_sector(dst, fifo ? SDCARD_FIFO0_LE : SDCARD_FIFO1_LE);
  return sector_count;
}

unsigned sdwrite_impl(const unsigned* src, unsigned sector, unsigned sector_count) {
  if (sector_count == 0) return 0;
  for (int i = 0; i < 128; ++i) IO_PORT(SDCARD_FIFO0_LE) = *src++;
  unsigned fifo = 0;
  for (unsigned b = 0; b < sector_count - 1; ++b) {
    IO_PORT(SDCARD_DATA) = sector++;
    IO_PORT(SDCARD_CMD) = (SDIO_CMD | SDIO_R1 | SDIO_ERR | SDIO_WRITE | SDIO_MEM | 24) | fifo;
    fifo ^= SDIO_FIFO;
    long port = fifo ? SDCARD_FIFO1_LE : SDCARD_FIFO0_LE;
    for (int i = 0; i < 128; ++i) IO_PORT(port) = *src++;
    while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) return b;
  }
  command((SDIO_CMD | SDIO_R1 | SDIO_ERR | SDIO_WRITE | SDIO_MEM | 24) | fifo, sector);
  return (IO_PORT(SDCARD_CMD) & SDIO_ERR) ? sector_count - 1 : sector_count;
}
