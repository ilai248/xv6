// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define HASHMAP_LEN 97

struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

typedef struct cache_bucket {
  struct buf* head;
  struct spinlock lock;
} cache_bucket;

cache_bucket cache_hash[HASHMAP_LEN];

uint hash(uint dev, uint blockno) {
  return (dev ^ blockno) % HASHMAP_LEN;
}

void
binit(void)
{
  struct buf *b;
  cache_bucket* bucket;

  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    initsleeplock(&b->lock, "buffer");
    b->refcnt = 0;
  }
  for (bucket = cache_hash; bucket < cache_hash + HASHMAP_LEN; bucket++) {
    initlock(&bucket->lock, "bcache");
    bucket->head = 0;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int buf_hash = hash(dev, blockno);
  cache_bucket* bucket = &cache_hash[buf_hash];

  // Is the block already cached?
  acquire(&bucket->lock);
  for (b = bucket->head; b != 0; b = b->next) {
    if (b->dev == dev && b->blockno == blockno) {
      b->refcnt++;
      release(&bucket->lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  acquire(&bcache.lock);
  for (int i = 0; i < NBUF; i++) {
    b = &bcache.buf[i];
    if (b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      b->prev = 0;

      // Add the new block to the buf hash.
      // acquire(&bucket->lock);
      struct buf* cache_head = cache_hash[buf_hash].head;
      if (cache_head) cache_head->prev = b;
      b->next = cache_head;
      cache_hash[buf_hash].head = b;

      release(&bucket->lock);
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  release(&bcache.lock);
  release(&bucket->lock);
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  uint buf_hash = hash(b->dev, b->blockno);
  cache_bucket* bucket = &cache_hash[buf_hash];

  acquire(&bucket->lock);

  // We don't care if this part is in a race condition, because we only change the refcount to 0.
  // We just need to know that when we changing the actual references of 'b' we don't get race condition.
  b->refcnt--;
  if (b->refcnt == 0) {
    acquire(&bcache.lock);
    if (b->refcnt == 0) {
      // no one is waiting for it.
      if (b->next) b->next->prev = b->prev;
      if (b->prev) b->prev->next = b->next;
      if (bucket->head == b) bucket->head = b->next;
    }
    release(&bcache.lock);
  }
  release(&bucket->lock);
}

void
bpin(struct buf *b) {
  acquire(&cache_hash[hash(b->dev, b->blockno)].lock);
  b->refcnt++;
  release(&cache_hash[hash(b->dev, b->blockno)].lock);
}

void
bunpin(struct buf *b) {
  acquire(&cache_hash[hash(b->dev, b->blockno)].lock);
  b->refcnt--;
  release(&cache_hash[hash(b->dev, b->blockno)].lock);
}


