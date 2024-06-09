#include <endeavour_defs.h>
#include "ext2.h"

struct Superblock {
  uint32_t inode_count;
  uint32_t block_count;
  uint32_t reserved_block_count;
  uint32_t free_block_count;
  uint32_t free_inode_count;
  uint32_t first_block;
  uint32_t log_block_size;  // log2(size) - 10
  uint32_t log_fragment_size;
  uint32_t blocks_per_group;
  uint32_t fragments_per_group;
  uint32_t inodes_per_group;
  uint32_t last_mount_time;
  uint32_t last_write_time;
  uint16_t mnt_count;
  uint16_t max_mnt_count;
  uint16_t ext2_signature;  // 0xef53
  uint16_t state;
  uint16_t err_handling;
  uint16_t version_minor;
  uint32_t last_check_time;
  uint32_t check_interval;
  uint32_t os_id;
  uint32_t version_major;
  uint16_t owner_user_id;
  uint16_t owner_group_id;
  // extended superblock (version >= 1)
  uint32_t first_non_reserved_inode;
  uint16_t inode_size;
  // other fields not needed for bootloader
};

struct GroupDescriptor {
  uint32_t block_usage_block;
  uint32_t inode_usage_block;
  uint32_t inode_table_block;
  uint16_t free_block_count;
  uint16_t free_inode_count;
  uint16_t dir_count;
};

struct DirEntryHeader {
  uint32_t inode;
  uint16_t entry_size;
  unsigned char name_size;
  unsigned char unused;
  char name[0];
};

static void* next_alloc;

static void* malloc(unsigned long size) {
  void* res = next_alloc;
  next_alloc += size;
  return res;
}

static struct Superblock *superblock;
static void *group_desc_table;
static void *inode_buf;
static uint32_t *indirect1_buf;
static uint32_t *indirect2_buf;
static uint32_t *indirect3_buf;
static uint32_t inode_buf_loaded_block;
static void *dir_buf;

static uint32_t block_size() { return 1024 << superblock->log_block_size; }
static bool read_block(void* dst, uint32_t block) {
  int sectors = 2 << superblock->log_block_size;
  if (block * sectors + sectors >= SDCARD_SECTOR_COUNT) return 0;
  return bios_sdread(dst, block * sectors, sectors) == sectors;
}

struct Inode* get_inode(uint32_t inode) {
  uint32_t group = (inode - 1) / superblock->inodes_per_group;
  uint32_t index = (inode - 1) % superblock->inodes_per_group;
  struct GroupDescriptor* group_descr = (group_desc_table + group * 32);
  uint32_t block = group_descr->inode_table_block + (index * superblock->inode_size) / block_size();
  if (inode_buf_loaded_block != block) {
    if (!read_block(inode_buf, block)) return 0;
    inode_buf_loaded_block = block;
  }
  return inode_buf + index * superblock->inode_size;
}

struct BlockIterator {
  const struct Inode* inode;
  int i0, i1, i2, i3;
};

static bool start_block_iter(const struct Inode* inode, struct BlockIterator* iter) {
  iter->inode = inode;
  iter->i0 = iter->i1 = iter->i2 = iter->i3 = 0;
  if (iter->inode->indirect1_block && !read_block(indirect1_buf, iter->inode->indirect1_block)) return 0;
  if (iter->inode->indirect2_block && !read_block(indirect2_buf, iter->inode->indirect2_block)) return 0;
  if (iter->inode->indirect3_block && !read_block(indirect3_buf, iter->inode->indirect3_block)) return 0;
  return 1;
}

static uint32_t next_block(struct BlockIterator* iter) {
  uint32_t max_i = 256 << superblock->log_block_size;
  while (1) {
    if (iter->i0 < 12) {
      uint32_t block = iter->inode->direct_blocks[iter->i0++];
      if (block)
        return block;
      else
        continue;
    }
    if (iter->inode->indirect1_block && iter->i1 < max_i) {
      uint32_t block = indirect1_buf[iter->i1++];
      if (block)
        return block;
      else
        continue;
    }
    if (iter->inode->indirect2_block && iter->i2 < max_i) {
      if (!read_block(indirect1_buf, indirect2_buf[iter->i2++])) return 0;
      iter->i1 = 0;
      continue;
    }
    if (iter->inode->indirect3_block && iter->i3 < max_i) {
      if (!read_block(indirect2_buf, indirect3_buf[iter->i3++])) return 0;
      iter->i2 = 0;
      continue;
    }
    return 0;
  }
}

static uint32_t read_dir(const struct Inode* inode, bool print, const char* search) {
  struct BlockIterator iter;
  uint32_t block;
  if (!start_block_iter(inode, &iter)) return 0;
  while ((block = next_block(&iter))) {
    if (!read_block(dir_buf, block)) return 0;
    int pos = 0;
    while (pos < block_size()) {
      struct DirEntryHeader* h = dir_buf + pos;
      pos += h->entry_size;
      if (h->inode == 0) continue;
      if (print) {
        bios_putc('*');
        bios_putc(' ');
        for (int i = 0; i < h->name_size; ++i) bios_putc(h->name[i]);
        bios_putc('\n');
      }
      if (search) {
        for (int i = 0; i < h->name_size; ++i) {
          if (search[i] != h->name[i]) continue;
        }
        if (search[h->name_size] == 0 || search[h->name_size] == '/') return h->inode;
      }
    }
  }
  return 0;
}

#define ROOT_INODE 2

struct Inode* find_inode(const char* path) {
  if (*path == '/') path++;
  uint32_t inode_id = ROOT_INODE;
  while (inode_id && *path != 0) {
    struct Inode* inode = get_inode(inode_id);
    if (!inode) return 0;
    inode_id = read_dir(inode, 0, path);
    while (*path != 0 && *path != '/') path++;
  }
  return get_inode(inode_id);
}

void print_dir(const struct Inode* inode) {
  read_dir(inode, 1, 0);
}

uint32_t read_file(const struct Inode* inode, void* dst, uint32_t max_size) {
  struct BlockIterator iter;
  uint32_t block;
  uint32_t size_done = 0;
  if (!start_block_iter(inode, &iter)) return 0;
  while ((block = next_block(&iter)) && size_done < max_size) {
    uint32_t sectors = 2 << superblock->log_block_size;
    uint32_t first_sector = block * sectors;
    uint32_t sectors_limit = (max_size - size_done + 511) >> 9;
    if (sectors > sectors_limit) sectors = sectors_limit;
    if (bios_sdread(dst, first_sector, sectors) != sectors) return size_done;
    dst += (sectors << 9);
    size_done += (sectors << 9);
  }
  return size_done < max_size ? size_done : max_size;
}

bool init_ext2_reader() {
  if (SDCARD_SECTOR_COUNT < 4) {
    bios_printf("[BOOT] No SD card\n");
    return 0;
  }
  next_alloc = (void*)(RAM_ADDR + 0x20000);
  superblock = malloc(1024);
  if (bios_sdread(superblock, 2, 2) != 2) {
    bios_printf("[BOOT] SD card IO error\n");
    return 0;
  }
  if (superblock->ext2_signature != 0xef53) {
    bios_printf("[BOOT] No EXT2 signature\n");
    return 0;
  }
  if (superblock->version_major == 0) superblock->inode_size = 128;
  group_desc_table = malloc(block_size());
  inode_buf = malloc(block_size());
  indirect1_buf = malloc(block_size());
  indirect2_buf = malloc(block_size());
  indirect3_buf = malloc(block_size());
  dir_buf = malloc(block_size());
  inode_buf_loaded_block = -1;
  if (!read_block(group_desc_table, superblock->log_block_size ? 1 : 2)) {
    bios_printf("[BOOT] IO error\n");
    return 0;
  }
  struct Inode* root_inode = get_inode(ROOT_INODE);
  if (!root_inode || !is_dir(root_inode)) {
    bios_printf("[BOOT] EXT2 root not found\n");
    return 0;
  }
  return 1;
}
