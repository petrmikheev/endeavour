#include <endeavour_defs.h>

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
};

void wait(int v) {
  for (volatile int i = 0; i < v; ++i);
}

int main() {
  bios_printf("usbtest2\n");
  volatile struct OHCICtrl* ctrl = (void*)0x40000;
  volatile void* mem = (void*)0x41000;

  *(volatile unsigned*)(mem + 0x0) = 0;
  *(volatile unsigned*)(mem + 0x100) = 0;
  *(volatile unsigned*)(mem + 0x200) = 0;

  ctrl->HcFmInterval = 0x35893f47;
  ctrl->HcPeriodicStart = 0x38f4;
  ctrl->HcHCCA = 0x41000;
  ctrl->HcCommandStatus = 0x6;

  wait(30);
  ctrl->HcControl = 0xb7;

  wait(30);
  ctrl->HcInterruptEnable = 0x80000002;
  *(volatile unsigned*)((void*)ctrl + 0x54) = 0x10;
  *(volatile unsigned*)((void*)ctrl + 0x58) = 0x10;

  bios_printf("ohci0x54 -> %8x\n", *(volatile unsigned*)((void*)ctrl + 0x54));
  bios_printf("ohci0x58 -> %8x\n", *(volatile unsigned*)((void*)ctrl + 0x58));

  wait(30);
  ctrl->HcControlHeadED = 0x41100;
  ctrl->HcBulkHeadED = 0x41200;
  ctrl->HcCommandStatus = 0x2;
  ctrl->HcCommandStatus = 0x4;
  ctrl->HcCommandStatus = 0x2;

  bios_printf("end\n");
  return 0;
}