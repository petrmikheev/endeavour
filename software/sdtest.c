#include <endeavour_defs.h>

static void wait(volatile int i) {
  while (i > 0) i--;
}

static	const	unsigned
		// Command bit enumerations
		SDIO_RNONE    = 0x00000000,
		SDIO_R1       = 0x00000100,
		SDIO_R2       = 0x00000200,
		SDIO_R1b      = 0x00000300,
		SDIO_WRITE    = 0x00000400,
		SDIO_MEM      = 0x00000800,
		SDIO_FIFO     = 0x00001000,
		SDIO_DMA      = 0x00002000,
		SDIO_CMDBUSY  = 0x00004000,
		SDIO_ERR      = 0x00008000,
		SDIO_CMDECODE = 0x00030000,
		SDIO_REMOVED  = 0x00040000,
		SDIO_PRESENTN = 0x00080000,
		SDIO_CARDBUSY = 0x00100000,
		SDIO_BUSY     = 0x00104800,
		SDIO_CMDERR   = 0x00200000,
		SDIO_RXERR    = 0x00400000,
		SDIO_RXECODE  = 0x00800000,
		// PHY enumerations
		SDIO_DDR      = 0x00004100,	// Requires CK90
		SDIO_DS       = 0x00004300,	// Requires DDR & CK90
		SDIO_W1       = 0x00000000,
		SDIO_W4       = 0x00000400,
		SDIO_W8	      = 0x00000800,
		SDIO_WBEST    = 0x00000c00,
		SDIO_PPDAT    = 0x00001000,	// Push pull drive for data
		SDIO_PPCMD    = 0x00002000,	// Push pull drive for cmd wire
		SDIO_PUSHPULL = SDIO_PPDAT | SDIO_PPCMD,
		SDIOCK_CK90   = 0x00004000,
		SDIOCK_SHUTDN = 0x00008000,
		// IO clock speeds
		SDIOCK_100KHZ = 0x000000fc,
		SDIOCK_200KHZ = 0x0000007f,
		SDIOCK_400KHZ = 0x00000041,
		SDIOCK_1MHZ   = 0x0000001b,
		SDIOCK_5MHZ   = 0x00000007,
		SDIOCK_12MHZ  = 0x00000004,
		SDIOCK_25MHZ  = 0x00000003,
		SDIOCK_50MHZ  = 0x00000002,
		SDIOCK_100MHZ = 0x00000001,
		SDIOCK_200MHZ = 0x00000000,
		SDIOCK_1P2V   = 0x00400000,
		SDIOCK_DS     = SDIOCK_25MHZ | SDIO_W4 | SDIO_PUSHPULL,
		SDIOCK_HS     = SDIOCK_50MHZ | SDIO_W4 | SDIO_PUSHPULL,
		// Speed abbreviations
		SDIOCK_SDR50  = SDIOCK_50MHZ  | SDIO_W4 | SDIO_PUSHPULL | SDIOCK_1P2V,
		SDIOCK_DDR50  = SDIOCK_50MHZ  | SDIO_W4 | SDIO_PUSHPULL | SDIO_DDR | SDIOCK_1P2V,
		SDIOCK_SDR104 = SDIOCK_100MHZ | SDIO_W4 | SDIO_PUSHPULL | SDIOCK_1P2V,
		SDIOCK_SDR200 = SDIOCK_200MHZ | SDIO_W4 | SDIO_PUSHPULL | SDIOCK_1P2V,
		// SDIOCK_HS400= SDIOCK_200MHZ | SDIO_W4 | SDIO_PUSHPULL | SDIO_DS,
		//
		SPEED_SLOW   = SDIOCK_100KHZ,
		SPEED_DEFAULT= SDIOCK_DS,
		SPEED_FAST   = SDIOCK_HS,
		//
		SECTOR_16B   = 0x04000000,
		SECTOR_512B  = 0x09000000,
		//
		SDIO_CMD     = 0x00000040,
		SDIO_R1ERR   = 0xff800000,
		SDIO_READREG  = SDIO_CMD | SDIO_R1,
		SDIO_READREGb = SDIO_CMD | SDIO_R1b,
		SDIO_READR2  = (SDIO_CMD | SDIO_R2),
		SDIO_WRITEBLK = (SDIO_CMD | SDIO_R1 | SDIO_ERR
				| SDIO_WRITE | SDIO_MEM) + 24,
		SDIO_READBLK  = (SDIO_CMD | SDIO_R1
					| SDIO_MEM) + 17;

/*static void sdio_wait() {
  while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);
}

static void	sdio_go_idle() {				// CMD0
  IO_PORT(SDCARD_DATA) = 0;
  IO_PORT(SDCARD_CMD) = SDIO_REMOVED | SDIO_CMD | SDIO_RNONE | SDIO_ERR;
  sdio_wait();
}

static unsigned sdio_send_if_cond(unsigned ifcond) { // CMD8
	unsigned	c, r;

	IO_PORT(SDCARD_DATA) = ifcond;
	IO_PORT(SDCARD_CMD) = SDIO_READREG+8;

	sdio_wait();

	c = IO_PORT(SDCARD_CMD);
	r = IO_PORT(SDCARD_DATA);

  bios_printf("SEND_IF_COND\n Cmd:  %x\n Data: %x\n", c, r);
	return r;
}

static void sdio_send_app_cmd() {
  IO_PORT(SDCARD_DATA) = 0;
  IO_PORT(SDCARD_CMD) = (SDIO_ERR | SDIO_CMD | SDIO_R1)+55;
  sdio_wait();
}

static unsigned sdio_send_op_cond(unsigned opcond) { // ACMD41
	unsigned	c, r;

	sdio_send_app_cmd();

	IO_PORT(SDCARD_DATA) = opcond;
	IO_PORT(SDCARD_CMD) = SDIO_READREG+41;

	sdio_wait();
	c = IO_PORT(SDCARD_CMD);
	r = IO_PORT(SDCARD_DATA);

	//dev->d_OCR = r;
  bios_printf("SEND_OP_COND %x\n Cmd:  %x\n Data: %x\n", opcond, c, r);
	return r;
}

void	sdio_dump_cid(unsigned* CID) {
  bios_printf("CID: %8x:%8x:%8x:%8x\n", CID[0], CID[1], CID[2], CID[3]);
	unsigned sn, md;

	sn = CID[2];
	sn = (sn << 8) | (CID[3] >> 24) & 0x0ff;
	md = (CID[3] >>  8) & 0x0fff;

	bios_printf("CID:\n"
"\tManufacturer ID:  0x%2x\n"
"\tApplication ID:   %c%c\n",
(CID[0] >> 24)&0x0ff,
		(CID[0] >> 16)&0x0ff,
		(CID[0] >>  8)&0x0ff);
bios_printf(
"\tProduct Name:     %c%c%c%c%c\n",
(CID[0]      )&0x0ff,
		(CID[1] >> 24)&0x0ff,
		(CID[1] >> 16)&0x0ff,
		(CID[1] >>  8)&0x0ff,
		(CID[1]      )&0x0ff);
bios_printf(
"\tProduct Revision: %x.%x\n"
"\tSerial Number:    0x%8x\n",
		(CID[2] >> 28)&0x00f,
		(CID[2] >> 24)&0x00f, sn);
	bios_printf(
"\tYear of Man.:     %d\n"
"\tMonth of Man.:    %d\n",
		((md>>4)+2000), md&0x0f);
}

void sdio_all_send_cid() {	// CMD2
	IO_PORT(SDCARD_DATA) = 0;
	IO_PORT(SDCARD_CMD) = (SDIO_ERR|SDIO_READR2)+2;

	sdio_wait();
  bios_printf("READ-CID %x\n", IO_PORT(SDCARD_CMD));

  unsigned CID[4];
	CID[0] = IO_PORT(SDCARD_FIFO0);
  CID[1] = IO_PORT(SDCARD_FIFO0);
  CID[2] = IO_PORT(SDCARD_FIFO0);
  CID[3] = IO_PORT(SDCARD_FIFO0);

  sdio_dump_cid(CID);
}

void sdio_send_cid(unsigned rca) {	// CMD10
	IO_PORT(SDCARD_DATA) = rca << 16;
	IO_PORT(SDCARD_CMD) = (SDIO_ERR|SDIO_READR2)+2;

	sdio_wait();
  bios_printf("SEND-CID %x\n", IO_PORT(SDCARD_CMD));

  unsigned CID[4];
	CID[0] = IO_PORT(SDCARD_FIFO0);
  CID[1] = IO_PORT(SDCARD_FIFO0);
  CID[2] = IO_PORT(SDCARD_FIFO0);
  CID[3] = IO_PORT(SDCARD_FIFO0);

  sdio_dump_cid(CID);
}

unsigned sdio_send_rca() {				// CMD3
	IO_PORT(SDCARD_DATA) = 0;
	IO_PORT(SDCARD_CMD) = (SDIO_ERR|SDIO_READREG)+3;

	sdio_wait();
	return (IO_PORT(SDCARD_DATA) >> 16)&0x0ffff;
}

void sdio_read_csd(unsigned rca) {	  // CMD 9
	// {{{
	//bios_printf("READ-CSD\n");

	IO_PORT(SDCARD_DATA) = rca << 16;
	IO_PORT(SDCARD_CMD) = (SDIO_CMD | SDIO_R2 | SDIO_ERR)+9;

	sdio_wait();

		unsigned	c, r;

		c = IO_PORT(SDCARD_CMD);
		r = IO_PORT(SDCARD_DATA);

		bios_printf("CMD9:    SEND_CSD\n");
		bios_printf("  Cmd:   %x\n", c);
		bios_printf("  Data:  %x\n", r);

	char CSD[16];
	for(int k=0; k<16; k+= 4) {
		unsigned	uv;
		uv = IO_PORT(SDCARD_FIFO0);
    bios_printf("CSD %8x\n", uv);
		CSD[k + 3] = uv & 0x0ff; uv >>= 8;
		CSD[k + 2] = uv & 0x0ff; uv >>= 8;
		CSD[k + 1] = uv & 0x0ff; uv >>= 8;
		CSD[k + 0] = uv;
	}

	unsigned	C_SIZE, READ_BL_LEN, CSD_STRUCTURE;
  unsigned d_sector_count;

	CSD_STRUCTURE = (CSD[0]>>6)&3;

  if (0 == CSD_STRUCTURE) {
		unsigned	ERASE_BLK_EN, C_SIZE_MULT, BLOCK_LEN, MULT,
				BLOCKNR, FILE_FORMAT_GRP, FILE_FORMAT,
				WRITE_BL_LEN, SECTOR_SIZE;

		READ_BL_LEN = CSD[5] & 0x0f;
		BLOCK_LEN = (READ_BL_LEN < 12) ? (1<<READ_BL_LEN) : READ_BL_LEN;
		C_SIZE = ((CSD[6]&0x3)<<10)
				|((CSD[7]&0x0ff)<<2)
				|((CSD[8]>>6)&0x03);
		C_SIZE_MULT = ((CSD[9]&3)<<2)|((CSD[10]>>7)&1);
		MULT = 1<<(C_SIZE_MULT+2);
		BLOCKNR = MULT * (C_SIZE+1);

		d_sector_count = BLOCKNR / 512;
  } else if (1 == CSD_STRUCTURE) {
		READ_BL_LEN = 9;
		C_SIZE = ((CSD[7] & 0x03f)<<16)
				|((CSD[8] & 0x0ff)<<8)
				|(CSD[9] & 0x0ff);
		d_sector_count = (C_SIZE+1) * 1024;
	} else {
		bios_printf("ERROR: Unknown CSD type: %d\n", CSD_STRUCTURE);
	}
	bios_printf("Size: %u KB\n", d_sector_count / 2);
}

void	sdio_select_card(unsigned rca) {			// CMD7
	IO_PORT(SDCARD_DATA) = rca << 16;
	IO_PORT(SDCARD_CMD) = (SDIO_ERR|SDIO_READREGb)+7;
	sdio_wait();
}*/

static unsigned command(unsigned cmd, unsigned arg) {
  IO_PORT(SDCARD_DATA) = arg;
  IO_PORT(SDCARD_CMD) = SDIO_CMD | SDIO_ERR | cmd;
  while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);
  bios_printf("CMD %8x -> %8x\tDATA %8x -> %8x\n", cmd, IO_PORT(SDCARD_CMD), arg, IO_PORT(SDCARD_DATA));
  return IO_PORT(SDCARD_DATA);
}

unsigned sdread1(unsigned* dst, unsigned sector, unsigned sector_count) {
  for (unsigned i = 0; i < sector_count; ++i) {
    command(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17, sector++);
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) return i;
    for (int i = 0; i < 128; ++i) *dst++ = IO_PORT(SDCARD_FIFO0_LE);
  }
  return sector_count;
}

unsigned sdread2(unsigned* dst, unsigned sector, unsigned sector_count) {
  if (sector_count == 0) return 0;
  command(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17, sector);
  unsigned fifo = SDIO_FIFO;
  unsigned cmd;
  for (unsigned b = 0; b < sector_count - 1; ++b) {
    if (IO_PORT(SDCARD_CMD) & SDIO_ERR) {
      //command(SDIO_R1 | 12, 0);
      return b;
    }
    IO_PORT(SDCARD_DATA) = ++sector;
    IO_PORT(SDCARD_CMD) = (SDIO_CMD | SDIO_R1 | SDIO_MEM | 17) | fifo;
    //IO_PORT(SDCARD_CMD) = (SDIO_MEM | 18) | fifo; //(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17) | fifo;
    fifo ^= SDIO_FIFO;
    long port = fifo ? SDCARD_FIFO1_LE : SDCARD_FIFO0_LE;
    for (int i = 0; i < 128; ++i) *dst++ = IO_PORT(port);
    while ((cmd=IO_PORT(SDCARD_CMD)) & SDIO_BUSY);
    bios_printf("*** %8x -> %8x\tDATA %8x\n", (SDIO_MEM | 18) | fifo, IO_PORT(SDCARD_CMD), IO_PORT(SDCARD_DATA));
  }
  int res = (IO_PORT(SDCARD_CMD) & SDIO_ERR) ? sector_count - 1 : sector_count;
  //command(SDIO_R1 | 12, 0);
  long port = fifo ? SDCARD_FIFO0_LE : SDCARD_FIFO1_LE;
  for (int i = 0; i < 128; ++i) *dst++ = IO_PORT(port);
  return res;
}

int main() {
  bios_printf("sdtest\n");

  /*for (int i = 0; i < 512/4; ++i) {
    IO_PORT(SDCARD_FIFO0) = i;
  }
  IO_PORT(SDCARD_DATA) = 0x0; // addr
  IO_PORT(SDCARD_CMD) = SDIO_WRITEBLK;
  while (IO_PORT(SDCARD_CMD) & SDIO_BUSY);*/

  /*for (int b = 0; b < 1; ++b) {
    command(SDIO_CMD | SDIO_R1 | SDIO_MEM | 17, b);
    for (int i = 0; i < 512/4; ++i) {
      bios_printf("%8x\n", IO_PORT(SDCARD_FIFO0));
    }
  }*/
  //IO_PORT(SDCARD_PHY) |= 0x00008000;
  unsigned* data = (unsigned*)(BIOS_RAM_ADDR + 0x400);
  {
    unsigned c = sdread1(data, 0, 2);
    bios_printf("%d   %8x %8x %8x ... %8x %8x\n", c, data[0], data[1], data[2], data[254], data[255]);
  }
  data[2] = 0x40002537;
  //bios_sdwrite(data, 0, 1);
  data[0] = data[1] = data[2] = data[254] = data[255] = -1;
  {
    unsigned c = sdread2(data, 0, 2);
    bios_printf("%d   %8x %8x %8x ... %8x %8x\n", c, data[0], data[1], data[2], data[254], data[255]);
  }

  return 0;
}
