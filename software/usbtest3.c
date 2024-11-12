#include <endeavour_defs.h>

void wait(int microseconds) {
  unsigned time, start_time;
  asm volatile("csrr %0, time" : "=r" (start_time));
  do {
    asm volatile("csrr %0, time" : "=r" (time));
  } while (time - start_time < microseconds);
}

static void* next_alloc = (void*)0x80500000;

void* malloc(unsigned long size) {
  void* res = next_alloc;
  next_alloc += size;
  return res;
}

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;

struct OHCICtrl {
  unsigned HcRevision;         // 0x00
  unsigned HcControl;          // 0x04
  unsigned HcCommandStatus;    // 0x08
  unsigned HcInterruptStatus;  // 0x0c
  unsigned HcInterruptEnable;  // 0x10
  unsigned HcInterruptDisable; // 0x14
  unsigned HcHCCA;             // 0x18
  unsigned HcPeriodCurrentED;  // 0x1c
  unsigned HcControlHeadED;    // 0x20
  unsigned HcControlCurrentED; // 0x24
  unsigned HcBulkHeadED;       // 0x28
  unsigned HcBulkCurrentED;    // 0x2c
  unsigned HcDoneHead;         // 0x30
  unsigned HcFmInterval;       // 0x34
  unsigned HcFmRemaining;      // 0x38
  unsigned HcFmNumber;         // 0x3c
  unsigned HcPeriodicStart;    // 0x40
  unsigned HcLSThreshold;      // 0x44
  unsigned HcRhDescriptorA;    // 0x48
  unsigned HcRhDescriptorB;    // 0x4c
  unsigned HcRhStatus;         // 0x50
  unsigned HcRhPortStatus[2];  // 0x54, 0x58
};

struct TD {
  unsigned flags;
  void* buf_start;
  struct TD* nextTD;
  void* buf_end;
};

struct ED {
  unsigned flags;
  unsigned tail;
  unsigned head;
  struct ED *nextED;
};

struct HCCA {
  struct ED *interrupt_table[32];
  short frame_number;
  short pad1;
  int done_head;
};

struct UsbRequest {
  uint8_t bmRequestType;
  uint8_t bRequest;
  uint16_t wValue;
  uint16_t wIndex;
  uint16_t wLength;
};

struct UsbDeviceDescriptor {
    uint8_t bLength;
    uint8_t bDescriptorType;
    uint16_t bcdUSB;
    uint8_t bDeviceClass;
    uint8_t bDeviceSubClass;
    uint8_t bDeviceProtocol;
    uint8_t bMaxPacketSize0;
    uint16_t idVendor;
    uint16_t idProduct;
    uint16_t bcdDevice;
    uint8_t iManufacturer;
    uint8_t iProduct;
    uint8_t iSerialNumber;
    uint8_t bNumConfigurations;
};

volatile static struct OHCICtrl* ctrl = (void*)USB_OHCI_BASE;
volatile static struct HCCA* hcca;
volatile static struct ED* default_ed;
volatile static struct TD* default_tds;

void init_hub() {
  ctrl->HcControl = 0x0;  // reset hub

  ctrl->HcFmInterval = (1<<31 /*FIT=1*/) | (0x2000 << 16 /*FSLargestDataPackage=1KB*/) | (0x2edf /*FrameInterval for 1ms frame*/);
  ctrl->HcPeriodicStart = 0x2a2f; // 90% of FrameInterval
  ctrl->HcInterruptEnable = 0x80000000; // disable all

  hcca = malloc(256);
  for (int i = 0; i < 32; ++i) hcca->interrupt_table[i] = 0;
  ctrl->HcHCCA = (long)hcca;

  default_ed = malloc(16);
  default_tds = malloc(16 * 3);

  default_ed->head = default_ed->tail = (long)default_tds;
  default_ed->nextED = 0;

  ctrl->HcControlHeadED = (long)default_ed;

  wait(50000);  // reset for 50ms

  ctrl->HcControl = 0x80 + (1<<4);  // operational state, allow only control transfers

  wait(1000);  // wait 1ms to update port connection status

  // disable ports
  ctrl->HcRhPortStatus[0] = 1;
  ctrl->HcRhPortStatus[1] = 1;
}

int usb_request(volatile struct ED* ed, const volatile struct UsbRequest* request, volatile void* data) {
  default_tds[0].flags = 0xf2000000;
  default_tds[0].nextTD = (void*)&default_tds[1];
  default_tds[0].buf_start = (void*)request;
  default_tds[0].buf_end = (char*)request + sizeof(struct UsbRequest)-1;

  int read = request->bmRequestType & 0x80;
  default_tds[1].flags = 0xf3040000 | (read ? 2<<19 : 1<<19);
  default_tds[1].nextTD = (void*)&default_tds[2];
  default_tds[1].buf_start = (void*)data;
  default_tds[1].buf_end = (void*)data + request->wLength - 1;

  ed->head = (long)&default_tds[0];
  ed->tail = (long)&default_tds[2];

  ctrl->HcCommandStatus = 2;
  wait(100000);

  if (ctrl->HcCommandStatus == 0 && (ed->head & 1) == 0 && (default_tds[0].flags>>28) == 0 && (default_tds[0].flags>>28) == 0) {
    return 0;
  }

  bios_printf("ERROR\nHcCommandStatus: 0x%x\n", ctrl->HcCommandStatus);
  bios_printf("ed.flags=%8x %d td[0].flags=%8x td[1].flags=%8x\n", ed->flags, (unsigned)ed->head&3, default_tds[0].flags, default_tds[1].flags);
  return -1;
}

int reset_port(int p) {
  ctrl->HcRhPortStatus[p] = 1 << 4;
  wait(100000);
  unsigned pstate = ctrl->HcRhPortStatus[p];
  if ((pstate&3) != 3) return -1;

  // max 8 byte, get direction from TD, USB address = 0, endpoint number = 0
  if (pstate & (1<<9))
    default_ed->flags = (8 << 16) | (1 << 13); // low speed
  else
    default_ed->flags = (8 << 16); // full speed

  struct UsbRequest request;
  struct UsbDeviceDescriptor descr;

  request.bmRequestType = 0x80;
  request.bRequest = 6; // GET_DESCRIPTOR
  request.wValue = 1 << 8; // device descriptor
  request.wIndex = 0;
  request.wLength = 8;

  if (usb_request(default_ed, &request, &descr) < 0) {
    ctrl->HcRhPortStatus[p] = 1;
    return -1;
  }

  default_ed->flags = ((unsigned)descr.bMaxPacketSize0 << 16) | (default_ed->flags & 0xffff);
  return 0;
}

int main() {
  bios_printf("OHCI test. HcRevision: 0x%x\n", ctrl->HcRevision);
  init_hub();

  for (int port = 0; port < 2; ++port) {
    bios_printf("USB%u: ", port + 1);
    if (!(ctrl->HcRhPortStatus[port] & 1)) {
      bios_printf("not connected\n");
      continue;
    }
    if (reset_port(port) < 0) goto test_port_error;

    struct UsbRequest request;
    struct UsbDeviceDescriptor ddev;

    request.bmRequestType = 0x80;
    request.bRequest = 6; // GET_DESCRIPTOR
    request.wValue = 1 << 8; // device descriptor
    request.wIndex = 0;
    request.wLength = sizeof(struct UsbDeviceDescriptor);

    if (usb_request(default_ed, &request, &ddev) < 0) goto test_port_error;

    char dstr[256];

    request.wValue = (3 << 8 /*string descriptor*/) | ddev.iManufacturer;
    request.wLength = 1;
    if (usb_request(default_ed, &request, &dstr) < 0) goto test_port_error;
    request.wLength = dstr[0];
    if (usb_request(default_ed, &request, &dstr) < 0) goto test_port_error;
    for (int i = 2; i < request.wLength; i += 2) bios_putc(dstr[i]);
    bios_putc(' ');

    request.wValue = (3 << 8 /*string descriptor*/) | ddev.iProduct;
    request.wLength = 1;
    if (usb_request(default_ed, &request, &dstr) < 0) goto test_port_error;
    request.wLength = dstr[0];
    if (usb_request(default_ed, &request, &dstr) < 0) goto test_port_error;
    for (int i = 2; i < request.wLength; i += 2) bios_putc(dstr[i]);
    bios_putc('\n');

    goto test_port_ok;
test_port_error:
    bios_printf("error\n");
test_port_ok:
    ctrl->HcRhPortStatus[port] = 1;  // disable
  }
  return 0;
}
