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
  struct TD *tail;
  struct TD *head;
  struct ED *nextED;
};

struct HCCA {
  struct ED *interrupt_table[32];
  short frame_number;
  short pad1;
  int done_head;
};

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;

struct UsbRequest {
  uint8_t bmRequestType;
  uint8_t bRequst;
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

#define SIMULATION

int main() {
  volatile struct OHCICtrl* ctrl = (void*)USB_OHCI_BASE;
  bios_printf("HcRevision: 0x%x\n", ctrl->HcRevision);
  ctrl->HcControl = 0x0;  // hub reset

#ifndef SIMULATION
  wait(10000); // keep hub reset for 10ms
#else
  wait(20); // during simulation 10ms is too long
#endif

  // * Should this initialization be done during hub reset, or after switching to operational state?
  // * What is the appropriate value for FSLargestDataPackage?
  //
  ctrl->HcFmInterval = (1<<31 /*FIT=1*/) | (0x2000 << 16 /*FSLargestDataPackage=1KB*/) | (0x2edf /*FrameInterval for 1ms frame*/);
  ctrl->HcPeriodicStart = 0x2a2f; // 90% of FrameInterval
  ctrl->HcInterruptEnable = 0x80000000; // disable all

  volatile struct HCCA* hcca = malloc(256);  // 0x80500000 - 0x805000ff
  for (int i = 0; i < 32; ++i) hcca->interrupt_table[i] = 0;
  ctrl->HcHCCA = (long)hcca;

  volatile struct ED *ed = malloc(16);       // 0x80500100 - 0x8050010f
  volatile struct TD *td = malloc(16 * 3);   // 0x80500110 - 0x8050013f

  // Initialize default endpoint for control transfers
  //
  // * How to control which port should be used for this endpoint?
  //
  ed->flags = 64 << 16; // max 64 byte, full-speed, get direction from TD, USB address = 0, endpoint number = 0
  ed->head = ed->tail = &td[0]; // head==tail, so it has no TDs
  ed->nextED = 0;

  // Set to operational state, enable control lists.
  // But ed.head == ed.tail, so it shouldn't do anything yet.
  ctrl->HcControlHeadED = (unsigned)ed;
  ctrl->HcControl = 0x80 + (1<<4);

#ifndef SIMULATION
  wait(500);

  // reset both ports
  ctrl->HcRhPortStatus[0] = 1<<4;
  ctrl->HcRhPortStatus[1] = 1<<4;

  wait(100000);
  for (int i = 0; i < 2; ++i) {
    int state = ctrl->HcRhPortStatus[i];
    bios_printf("port%u: connected=%u enabled=%u\n", i, state & 1, (state>>1) & 1);
  }
#else
  // skip port reset because it is too slow for simulation
#endif

  struct UsbRequest *request = malloc(sizeof(struct UsbRequest));                 // 0x80500140 - 0x80500147
  struct UsbDeviceDescriptor *descr = malloc(sizeof(struct UsbDeviceDescriptor)); // 0x80500148 - 0x80500159
  for (char* p = descr; p < (char*)(descr + 1); ++p) *p = 0; // fill with zeros

  // Request UsbDeviceDescriptor
  request->bmRequestType = 0x80;
  request->bRequst = 6; // GET_DESCRIPTOR
  request->wValue = 1;
  request->wIndex = 0;
  request->wLength = sizeof(struct UsbDeviceDescriptor);

  td[0].flags = (7<<21 /*no interrupt*/) | (0<<19 /*SETUP*/);
  td[0].nextTD = &td[1];
  td[0].buf_start = request;
  td[0].buf_end = (char*)request + sizeof(struct UsbRequest)-1;

  // Receive UsbDeviceDescriptor
  td[1].flags = (7<<21 /*no interrupt*/) | (2<<19 /*IN*/);
  td[1].nextTD = &td[2];
  td[1].buf_start = descr;
  td[1].buf_end = (char*)descr + sizeof(struct UsbDeviceDescriptor)-1;

  for (int i = 0; i < 2; ++i) {
    bios_printf("td[%u] = { %08x %08x %08x %08x }\n", i, td[i].flags, td[i].buf_start, td[i].nextTD, td[i].buf_end);
  }

  // Start processing UsbDeviceDescriptor request
  ed->tail = &td[2];
  ctrl->HcCommandStatus = 2;  // ControlListFilled=1

#ifndef SIMULATION
  wait(1000000);
#else
  wait(1000);  // Simulation fails with "FAILURE Tilelink decoder miss ???"
#endif

  bios_printf("HcCommandStatus: 0x%x\n", ctrl->HcCommandStatus);
  bios_printf("ed.flags=%8x %d td[0].flags=%8x td[1].flags=%8x\n", ed->flags, (unsigned)ed->head&3, td[0].flags, td[1].flags);

  for (char* p = descr; p < (char*)(descr + 1); ++p) bios_printf("%02x ", *p);
  bios_printf("\n");

  bios_printf("end\n");
  return 0;
}
