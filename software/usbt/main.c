#include "usb_hw.h"
#include "usb_core.h"
#include <endeavour_defs.h>

int main() {
  bios_printf("usbtest\n");
  usbhw_init(0x400);
  usbhw_reset();
  for (volatile int i = 0; i < 10000000; ++i);
  //usb_init();
  struct usb_device dev;
  usb_reset_device(&dev);
  usb_configure_device(&dev, 0);
  bios_printf("usbtest_end\n");
  return 0;
}
