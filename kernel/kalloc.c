// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

#define KMEM_LEN 4
#define CPU_KMEM_LEN 5

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

typedef struct mem_list {
  struct spinlock lock;
  struct run *freelist;
} mem_list;

mem_list kmems[NPROC];

int get_cpid() {
  push_off();
  int pid = cpuid();
  pop_off();
  return pid;
}

void
kinit()
{
  char kmem_name[] = {'k', 'm', 'e', 'm', 0, 0};

  for (int i = 0; i < NPROC; i++) {
    kmem_name[KMEM_LEN] = i + '0' - 0;
    initlock(&kmems[i].lock, kmem_name);
    kmems[i].freelist = 0;
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  
  int cpid = get_cpid();
  acquire(&kmems[cpid].lock);
  r->next = kmems[cpid].freelist;
  kmems[cpid].freelist = r;
  release(&kmems[cpid].lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run* r;
  int cpid = get_cpid(), kmem_index = 0;
  // printf("cpid, %d\n", cpid);

  // Search for a page - starting with our cpid's free list.
  for(int i = cpid; i < cpid + NPROC; i++) {
    kmem_index = i % NPROC;
    acquire(&kmems[kmem_index].lock);
    r = kmems[kmem_index].freelist;
    if (r) {
      kmems[kmem_index].freelist = r->next;
      i = cpid + NPROC; // We found a free page - break from the loop.
    };
    release(&kmems[kmem_index].lock);
  }

  if (r) memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
