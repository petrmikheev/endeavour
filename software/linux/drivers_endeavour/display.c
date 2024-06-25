#include <asm/io.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <linux/timer.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/mm.h>

#define VIDEO_CFG           (display_regs + 0x0)
#define VIDEO_TEXT_ADDR     (display_regs + 0x4)
#define VIDEO_GRAPHIC_ADDR  (display_regs + 0x8)
#define VIDEO_REG_INDEX     (display_regs + 0xC)
#define VIDEO_REG_VALUE     (display_regs + 0x10)  // write-only

// VIDEO_CFG flags
#define VIDEO_640x480     1
#define VIDEO_1024x768    2
#define VIDEO_1280x720    3
#define VIDEO_TEXT_ON     4
#define VIDEO_GRAPHIC_ON  8
#define VIDEO_FONT_HEIGHT(X) ((((X)-1)&15) << 4) // allowed range [6, 16]
#define VIDEO_FONT_WIDTH(X) ((((X)-1)&7) << 8)   // allowed range [6, 8]
#define VIDEO_RGB565      0
#define VIDEO_RGAB5515    0x800

static void __iomem * display_regs;
//static struct timer_list display_timer;
//static void* display_buffer;

/*#define DISPLAY_TIMER_RATE 40

static int tt = 0;

static char vhex(int c) { return "0123456789ABCDEF"[c & 15]; }

static void display_timer_handler(struct timer_list *t)
{
  char* text_buf = display_buffer + (ioread32(VIDEO_TEXT_ADDR) & 0xffff);
  tt++;
  text_buf[0] = vhex(tt >> 12);
  text_buf[2] = vhex(tt >> 8);
  text_buf[4] = vhex(tt >> 4);
  text_buf[6] = vhex(tt);
  mod_timer(&display_timer, jiffies + HZ / DISPLAY_TIMER_RATE);
}*/

struct CharmapData {
  unsigned index;
  unsigned value;
};

void set_endeavour_sbi_console(bool v);

static long display_ioctl(struct file *filp, unsigned int cmd, unsigned long arg) {
  // printk("display_ioctl cmd=%u arg=%lu\n", cmd, arg);
  unsigned v;
  struct CharmapData cd;
  switch (cmd) {
    case 0xaa0: // get text addr
      v = ioread32(VIDEO_TEXT_ADDR) & 0x3fffff;
      (void)copy_to_user((void*)arg, &v, sizeof(v));
      break;
    case 0xaa1: // get graphic addr
      v = ioread32(VIDEO_GRAPHIC_ADDR) & 0x3fffff;
      (void)copy_to_user((void*)arg, &v, sizeof(v));
      break;
    case 0xaa2: // set text addr
      (void)copy_from_user(&v, (void*)arg, sizeof(v));
      iowrite32(0x80000000 + (v & 0x3fffff), VIDEO_TEXT_ADDR);
      break;
    case 0xaa3: // set graphic addr
      (void)copy_from_user(&v, (void*)arg, sizeof(v));
      iowrite32(0x80000000 + (v & 0x3fffff), VIDEO_GRAPHIC_ADDR);
      break;
    case 0xaa4: // get cfg
      v = ioread32(VIDEO_CFG);
      (void)copy_to_user((void*)arg, &v, sizeof(v));
      break;
    case 0xaa5: // set cfg
      (void)copy_from_user(&v, (void*)arg, sizeof(v));
      iowrite32(v, VIDEO_CFG);
      break;
    case 0xaa6: // set charmap
      (void)copy_from_user(&cd, (void*)arg, sizeof(struct CharmapData));
      iowrite32(cd.index, VIDEO_REG_INDEX);
      iowrite32(cd.value, VIDEO_REG_VALUE);
      break;
    case 0xaa7:
      set_endeavour_sbi_console(0);
      break;
    default:
      return -1;
  }
  return 0;
}

static int display_mmap(struct file *filp, struct vm_area_struct *vma) {
  //printk("display mmap");
  return remap_pfn_range(vma, vma->vm_start, 0x80000000 >> PAGE_SHIFT, vma->vm_end - vma->vm_start, vma->vm_page_prot);
}

static const struct file_operations display_ops = {
    .owner = THIS_MODULE,
    /*.open = my_open,
    .read = my_read,
    .write = my_write,
    .release = my_release,*/
    .unlocked_ioctl = display_ioctl,
    .mmap = display_mmap
};

static int display_probe(struct platform_device *pdev) {
  printk("Initializing display driver\n");
  display_regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
  if (IS_ERR(display_regs))
    return PTR_ERR(display_regs);
  //display_buffer = ioremap(0x80000000, 0x400000);
  //if (IS_ERR(display_buffer))
  //  return PTR_ERR(display_buffer);
  //timer_setup(&display_timer, display_timer_handler, 0);
  //mod_timer(&display_timer, jiffies + HZ / DISPLAY_TIMER_RATE);
  int textbuf_major = register_chrdev(0, "display", &display_ops);
  if (textbuf_major < 0) {
    printk("Can't register display chrdev\n");
    return textbuf_major;
  }
  dev_t devNo = MKDEV(textbuf_major, 0);
  struct class *pClass = class_create("display");
  if (IS_ERR(pClass)) {
    printk("can't create class\n");
    unregister_chrdev_region(devNo, 1);
    return -1;
  }
  struct device *pDev;
  if (IS_ERR(pDev = device_create(pClass, NULL, devNo, NULL, "display"))) {
    printk("can't create device /dev/display\n");
    class_destroy(pClass);
    unregister_chrdev_region(devNo, 1);
    return -1;
  }
  return 0;
}

static const struct of_device_id display_match[] = {
  { .compatible = "endeavour,display" },
  {}
};

static struct platform_driver display_driver = {
  .driver = {
    .name = "endeavour_display",
    .of_match_table = display_match,
  },
  .probe = display_probe,
};
builtin_platform_driver(display_driver);
