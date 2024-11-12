#ifndef ENDEAVOUR_EXT2
#define ENDEAVOUR_EXT2

typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
#define bool int

struct Inode {
  uint16_t mode;
  uint16_t uid;
  uint32_t size_lo;
  uint32_t atime;
  uint32_t ctime;
  uint32_t mtime;
  uint32_t dtime;
  uint16_t gid;
  uint16_t link_count;
  uint32_t sector_count;
  uint32_t flags;
  uint32_t osd1;
  uint32_t direct_blocks[12];
  uint32_t indirect1_block;
  uint32_t indirect2_block;
  uint32_t indirect3_block;
  uint32_t gen_number;
  uint32_t file_acl_block;
  uint32_t dir_acl_block;  // or size_hi
  uint32_t fragment_block_addr;
  uint32_t osd2[3];
};

bool init_ext2_reader(unsigned start_sector);

// uses RAM_ADDR + 0x20000 for memory allocations
void* ext2_malloc(unsigned long size);

static inline bool is_dir(const struct Inode* inode) { return (inode->mode & 0xf000) == 0x4000; }
static inline bool is_regular_file(const struct Inode* inode) { return (inode->mode & 0xf000) == 0x8000; }

struct Inode* find_inode(const char* path);
void print_dir(const struct Inode* inode);
uint32_t read_file(const struct Inode* inode, void* dst, uint32_t max_size);

#endif