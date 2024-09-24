#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"

uint64 getFreeMem(void);
int getNProc();

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
enum PgaccessParams {START_VADDR, PAGE_COUNT, ABITS_ADDR};

int sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 addr = 0, abitsAddr = 0;
  unsigned int abits = 0;
  int count = 0;
  pte_t* pte = 0;
  pagetable_t pagetable = myproc()->pagetable;

  argaddr(START_VADDR, &addr);
  argint(PAGE_COUNT, &count);
  argaddr(ABITS_ADDR, &abitsAddr);
  if (count < 0) return -1; // "Count" shouldn't be negative.

  for(int i = 0; i < count; i++) {
    if ((pte = walk(pagetable, addr + i*PGSIZE, 0)) == 0)
      panic("pgaccess: null pte detected");
    if (*pte & PTE_A) {
      abits += 1 << i; // Add the page to the bitmap.
      *pte ^= PTE_A; // Reset the A bit (to 0).
    }
  }
  
  if (copyout(pagetable, abitsAddr, (char*)&abits, sizeof(abits)) < 0)
    return -1;
  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_trace(void)
{
  int syscallMask;
  argint(0, &syscallMask);
  myproc()->syscallMask = syscallMask;
  return 0;
}

uint64
sys_sysinfo(void)
{
  struct proc* p = myproc();

  uint64 addr;
  argaddr(0, &addr);

  struct sysinfo si;
  si.freemem = getFreeMem();
  si.nproc = getNProc();

  if (copyout(p->pagetable, addr, (char*)&si, sizeof(si)) < 0)
    return -1;
  return 0;
}
