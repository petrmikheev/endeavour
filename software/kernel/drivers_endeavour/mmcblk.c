#ifdef NOT_IMPLEMENTED
#include <linux/genhd.h>
#include <linux/blkdev.h>
#include <linux/fs.h>

void block_dev_init()
{
    spinlock_t *lk;  /* Main lock for the device */
    struct gendisk *gdisk;
    int major_number = register_blkdev(101, "mmcblk");

    gdisk = alloc_disk(1);

    if (!gdisk) {
        return;
    }

    spin_lock_init(&lk);

    snprintf(gdisk->disk_name, 8, "blockdev");  /* Block device file name: "/dev/blockdev" */

    gdisk->flags = GENHD_FL_NO_PART_SCAN;  /* Kernel won't scan for partitions on the new disk */
    gdisk->major = major_number;
    gdisk->fops = &blockdev_ops;  /* Block device file operations, see below */
    gdisk->first_minor = 0;

    gdisk->queue = blk_init_queue(req_fun, &lk);  /* Init I/O queue, see below */

    set_capacity(block_device->gdisk, 1024 * 512);  /* Set some random capacity, 1024 sectors (with size of 512 bytes) */

    add_disk(gdisk);
}


int blockdev_open(struct block_device *dev, fmode_t mode)
{
    printk("Device %s opened"\n, dev->bd_disk->disk_name);
    return 0;
}

void blockdev_release(struct gendisk *gdisk, fmode_t mode)
{
    printk("Device %s closed"\n, dev->bd_disk->disk_name);
}

int blockdev_ioctl (struct block_device *dev, fmode_t mode, unsigned cmd, unsigned long arg)
{
    return -ENOTTY; /* ioctl not supported */
}

static struct block_device_operations blockdev_ops = {
    .owner = THIS_MODULE,
    .open = blockdev_open,
    .release = blockdev_release,
    .ioctl = blockdev_ioctl
};

static void block_request(struct request_queue *q)
{
    int direction;
    int err = -EIO;
    u8 *data;
    struct request *req = blk_fetch_request(q); /* get one top request from the queue */

    while (req) {
        if (__blk_end_request_cur(req, err)) {  /* check for the end */
            break;
        }

        /* Data processing */

        direction = rq_data_dir(req);

        if (direction == WRITE) {
            printk("Writing data to the block device\n");
        } else {
            printk("Reading data from the block devicen\n");
        }

        data = bio_data(req->bio); /* Data buffer to perform I/O operations */

        /* */

        req = blk_fetch_request(q); /* get next request from the queue */
    }
}
#endif
