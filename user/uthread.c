#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* Possible states of a thread: */
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

typedef struct thread_context {
  uint64 ra;
  uint64 sp;

  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
} thread_context;

struct thread {
  char              stack[STACK_SIZE]; /* the thread's stack */
  int               state;             /* FREE, RUNNING, RUNNABLE */
  int               hasRun;
  thread_context    context;           /* the collee registers */
};
struct thread all_thread[MAX_THREAD];
struct thread *current_thread;
extern void thread_switch(uint64, uint64, uint64);

char* statename(int state) {
  if (state == FREE) return "FREE";
  else if (state == RUNNABLE) return "RUNNABLE";
  else return "RUNNING";
}

void 
thread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

void printContext(struct thread* t) {
  printf("Thread Context (%x, %x, %x):\n", t->context.ra, t->context.sp, t->context.s0);
  for (int i = 0; i < 14; i++) printf("%x, ", ((uint64*)&t->context)[i]); // Print current register.
  printf("\n");
}

void printThreads() {
  struct thread* t;

  printf("Thread List (%p):\n", all_thread);
  t = all_thread;
  for(int i = 0; i < MAX_THREAD; i++){
    if (t == current_thread) printf("[*]\t");
    printf("%d) state %d (%s)\n", i, t->state, statename(t->state));
    ++t;
  }
}

void 
thread_schedule(void)
{
  struct thread *t, *next_thread;
  // printThreads();

  /* Find another runnable thread. */
  // printf("Runnable? %d\n", current_thread->state);
  next_thread = 0;
  t = current_thread + 1; // Start searching at the current thread.
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
      t = all_thread;
    if(t->state == RUNNABLE) {
      next_thread = t;
      break;
    }
    ++t;
  }

  // No available thread found (including the currently executing thread).
  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  // printf("hasRun: %d\n", current_thread->hasRun);
  // printf("\n");
  // If we are actually switching threads -> Set the next thread's state to RUNNING and switch the registers.
  if (current_thread != next_thread) {         /* switch threads?  */
    // printf("Current Thread: %d\n", current_thread->state);
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;

    // printContext(t);
    if (current_thread->hasRun) current_thread->hasRun = 1;
    thread_switch((uint64)&t->context, (uint64)&current_thread->context, current_thread->hasRun++); /* (Prev Context, New Context) */
    // printThreads();
    // printf("\n");
    // printContext(current_thread);
    // printf("\nStack: %p\n", current_thread->stack);

    // printf("Thread List (%p):\n", all_thread);
    // next_thread = 0;
    // t = all_thread;
    // for(int i = 0; i < MAX_THREAD; i++){
    //   printf("%d) state %d (%s)\n", i, t->state, statename(t->state));
    //   ++t;
    // }
  } else {
    current_thread->state = RUNNING;
    next_thread = 0;
  }
}

void 
thread_create(void (*func)())
{
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }

  if (t == all_thread + MAX_THREAD) {
    printf("MAX_THREAD limit was reached");
    return;
  }

  // Set the thread's state to RUNNABLE and set its stack and starting point ("func") as "sp" and "ra" respectively.
  t->state = RUNNABLE;
  t->hasRun = 0;
  t->context.sp = (uint64)t->stack + STACK_SIZE;
  t->context.ra = (uint64)func;
}

void 
thread_yield(void)
{
  // printf("Setting state to runnable\n");
  current_thread->state = RUNNABLE;
  thread_schedule();
}

volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
  int i;
  printf("thread_a started\n");
  a_started = 1;
  while(b_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
    a_n += 1;
    thread_yield();
  }
  printf("thread_a: exit after %d\n", a_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_b(void)
{
  int i;
  printf("thread_b started\n");
  b_started = 1;
  while(a_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
    b_n += 1;
    thread_yield();
  }
  printf("thread_b: exit after %d\n", b_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_c(void)
{
  int i;
  printf("thread_c started\n");
  c_started = 1;
  while(a_started == 0 || b_started == 0)
    thread_yield();
  
  // The following loop's iteration count is changed to 5 in order to ease the debugging process.
  for (i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
    c_n += 1;
    thread_yield();
  }
  printf("thread_c: exit after %d\n", c_n);

  current_thread->state = FREE;
  thread_schedule();
}

int 
main(int argc, char *argv[]) 
{
  a_started = b_started = c_started = 0;
  a_n = b_n = c_n = 0;
  thread_init();
  thread_create(thread_a);
  thread_create(thread_b);
  thread_create(thread_c);
  thread_schedule();
  exit(0);
}
