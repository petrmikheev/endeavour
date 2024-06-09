/*#include <linux/platform_device.h>

static int display_probe(struct platform_device *pdev) {
  printk("diplay_probe\n");
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
*/
