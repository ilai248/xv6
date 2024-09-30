#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

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

  // Print function backtrace.
  backtrace();

  argint(0, &n);
  if(n < 0)
    n = 0;
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

uint64 sys_sigreturn(void)
{
  struct proc* p = myproc();
  *p->trapframe = p->savedTrapframe;
  p->executingAlarm = 0;

  // Set the user's a0 currectly (as it will be changed to the syscall's return value).
  return p->trapframe->a0;
}

uint64 sys_sigalarm(void)
{
  struct proc* p = myproc();
  int interval = 0;
  uint64 handlerAddr = 0;
  argint(0, &interval);
  argaddr(1, &handlerAddr);
  
  // Set lastAlarm to 0 (which stops the sigalarm) if we get a sigalarm(0, 0) call.
  if (interval == 0 && handlerAddr == 0) {
    p->lastAlarm = 0;
    return 0;
  }

  // sigalarm is already running. (will be called once in the - in test3 - test since the test doesn't call sigalarm(0, 0) after test1).
  if (p->lastAlarm != 0) return 1;

  acquire(&tickslock);
  p->lastAlarm = ticks;
  release(&tickslock);

  p->alarmInterval = interval;
  p->alarmHandler = handlerAddr;

  return 0;
}
