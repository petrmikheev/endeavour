#include <endeavour_defs.h>

#define USB_CTRL       0x400  // [RW] Control of USB reset, SOF and Tx FIFO flush
#define USB_STATUS     0x404  // [R] Line state, Rx error status and frame time
#define USB_IRQ_ACK    0x408  // [W] Acknowledge IRQ by setting relevant bit
#define USB_IRQ_STS    0x40c  // [R] Interrupt status
#define USB_IRQ_MASK   0x410  // [RW] Interrupt mask
#define USB_XFER_DATA  0x414  // [RW] Tx payload transfer length
#define USB_XFER_TOKEN 0x418  // [RW] Transfer control info (direction, type)
#define USB_RX_STAT    0x41c  // [R] Transfer status (Rx length, error, idle)
#define USB_DATA       0x420  // [RW] FIFO

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;

struct UsbDeviceDescriptor
{
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
} __attribute__ ((packed));

#define REQ_GET_STATUS        0x00
#define REQ_CLEAR_FEATURE     0x01
#define REQ_SET_FEATURE       0x03
#define REQ_SET_ADDRESS       0x05
#define REQ_GET_DESCRIPTOR    0x06
#define REQ_SET_DESCRIPTOR    0x07
#define REQ_GET_CONFIGURATION 0x08
#define REQ_SET_CONFIGURATION 0x09
#define REQ_GET_INTERFACE     0x0A
#define REQ_SET_INTERFACE     0x0B
#define REQ_SYNC_FRAME        0x0C

// Descriptor types
#define DESC_DEVICE           0x01
#define DESC_CONFIGURATION    0x02
#define DESC_STRING           0x03
#define DESC_INTERFACE        0x04
#define DESC_ENDPOINT         0x05
#define DESC_DEV_QUALIFIER    0x06
#define DESC_OTHER_SPEED_CONF 0x07
#define DESC_IF_POWER         0x08

// Device Requests (bmRequestType)
#define REQDIR_HOSTTODEVICE        (0 << 7)
#define REQDIR_DEVICETOHOST        (1 << 7)
#define REQTYPE_STANDARD           (0 << 5)
#define REQTYPE_CLASS              (1 << 5)
#define REQTYPE_VENDOR             (2 << 5)
#define REQREC_DEVICE              (0 << 0)
#define REQREC_INTERFACE           (1 << 0)
#define REQREC_ENDPOINT            (2 << 0)
#define REQREC_OTHER               (3 << 0)

// USB PID generation macro
#define PID_GENERATE(pid3, pid2, pid1, pid0) ((pid0 << 0) | (pid1 << 1) | (pid2 << 2) | (pid3 << 3) | ((!pid0) << 4) | ((!pid1) << 5) | ((!pid2) << 6)  | ((!pid3) << 7))

// USB PID values
#define PID_OUT        PID_GENERATE(0,0,0,1) // 0xE1
#define PID_IN         PID_GENERATE(1,0,0,1) // 0x69
#define PID_SOF        PID_GENERATE(0,1,0,1) // 0xA5
#define PID_SETUP      PID_GENERATE(1,1,0,1) // 0x2D

#define PID_DATA0      PID_GENERATE(0,0,1,1) // 0xC3
#define PID_DATA1      PID_GENERATE(1,0,1,1) // 0x4B

#define PID_ACK        PID_GENERATE(0,0,1,0) // 0xD2
#define PID_NAK        PID_GENERATE(1,0,1,0) // 0x5A
#define PID_STALL      PID_GENERATE(1,1,1,0) // 0x1E


void transfer_out(int pid, int addr, int endpoint, int handshake, int request, char* data, int len) {
  for (int i = 0; i < len; ++i) {
    IO_PORT(USB_DATA) = data[len];
  }
  IO_PORT(USB_XFER_DATA) = len;
  unsigned ctrl = 1<<31;  // token_start
  if (handshake) ctrl |= 1 << 29; // wait or timeout
  if (request == PID_DATA1) ctrl |= 1 << 28; // DATA0 or DATA1
  ctrl |= (pid << 16) | (addr << 9) | (endpoint << 5);
  IO_PORT(USB_XFER_TOKEN) = ctrl;

  while (IO_PORT(USB_RX_STAT) & (1 << 31));

  if (handshake) {
    bios_printf("handshake not implemented\n");
    // TODO
  }
}

void transfer_in(int pid, int addr, int endpoint, uint8_t *rx, int rx_length) {
  IO_PORT(USB_XFER_DATA) = 0;
  IO_PORT(USB_XFER_TOKEN) = (pid << 16) | (addr << 9) | (endpoint << 5) |
                            (1<<31) | (1<<30) | (1<<29);
  while (IO_PORT(USB_RX_STAT) & (1 << 31));
  int status;
  while (!((status = IO_PORT(USB_RX_STAT)) & (1 << 28)));
  if (status & (1 << 30)) {
    bios_printf("crc error\n");
    return;
  }
  if (status & (1 << 29)) {
    bios_printf("timeout\n");
    return;
  }
  unsigned response = (status >> 16) & 0xff;
  int count = status & 0xffff;
  bios_printf("resp 0x%x  count %d\n", response, count);
  if (count > rx_length) count = rx_length;
  for (int i = 0; i < count; ++i) *rx++ = IO_PORT(USB_DATA);
}

static int usb_setup_packet(int device_address, uint8_t request_type, uint8_t request, uint16_t value, uint16_t index, uint16_t length)
{
    uint8_t usb_request[8];
    int idx = 0;

    /* bmRequestType:
        D7 Data Phase Transfer Direction
        0 = Host to Device
        1 = Device to Host
        D6..5 Type
        0 = Standard
        1 = Class
        2 = Vendor
        3 = Reserved
        D4..0 Recipient
        0 = Device
        1 = Interface
        2 = Endpoint
        3 = Other
     */
    usb_request[idx++] = request_type;
    usb_request[idx++] = request;
    usb_request[idx++] = (value >> 0) & 0xFF;
    usb_request[idx++] = (value >> 8) & 0xFF;
    usb_request[idx++] = (index >> 0) & 0xFF;
    usb_request[idx++] = (index >> 8) & 0xFF;
    usb_request[idx++] = (length >> 0) & 0xFF;
    usb_request[idx++] = (length >> 8) & 0xFF;

    // Send SETUP token + DATA0 (always DATA0)
    transfer_out(PID_SETUP, device_address, 0, 0 /*1*/, PID_DATA0, usb_request, idx);
}

int main() {
  bios_printf("usbtest\n");
  while ((IO_PORT(USB_STATUS) & 3) == 0);
  switch (IO_PORT(USB_STATUS) & 3) {
    case 1: bios_printf("full speed\n"); break;
    case 2: bios_printf("low speed\n"); break;
    default: bios_printf("invalid speed\n");
  }
  for (volatile int i = 0; i < 1000000; ++i);
  struct UsbDeviceDescriptor desc;

  usb_setup_packet(0, REQDIR_DEVICETOHOST | REQREC_DEVICE | REQTYPE_STANDARD, REQ_GET_DESCRIPTOR, DESC_DEVICE, 0, sizeof(struct UsbDeviceDescriptor));
  transfer_in(PID_IN, 0, 0, &desc, 8);
  bios_printf("len=%d descType=%d\n", (unsigned)desc.bLength, (unsigned)desc.bDescriptorType);
  bios_printf("cdUsb=0x%x\n", desc.bcdUSB);
  bios_printf("class=0x%x sub=0x%x prot=0x%x pacSize=%d\n", (unsigned)desc.bDeviceClass,
              (unsigned)desc.bDeviceSubClass, (unsigned)desc.bDeviceProtocol, (unsigned)desc.bMaxPacketSize0);
  return 0;
}
