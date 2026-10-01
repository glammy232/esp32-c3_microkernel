#include <stdint.h>
#include "proc.h"
#include "defs.h"

extern uint32_t sys_fork(void);
extern uint32_t sys_exec(void);
extern uint32_t	sys_wait(void);
extern uint32_t sys_read(void);
extern uint32_t sys_getpid(void);
extern uint32_t sys_exit(void);
extern uint32_t sys_kill(void);

uint32_t argraw(int n)
{
  struct proc *p; /* = myproc(); */
  switch (n) {
  case 0: return p->trapframe->a0;
  case 1: return p->trapframe->a1;
  case 2: return p->trapframe->a2;
  case 3: return p->trapframe->a3;
  case 4: return p->trapframe->a4;
  case 5: return p->trapframe->a5;
  }
  /* panic("argraw"); */
  return -1;
}

/* write signed(int) argument to ip */
void argint(int n, int *ip)
{
  *ip = argraw(n);
}

// get pointer like an argument
void argaddr(int n, uint32_t *ip)
{
  *ip = argraw(n);
}



static uint32_t (*syscalls[])(void) = {
	[SYS_fork]		= sys_fork,
	[SYS_exec]		= sys_exec,
	[SYS_wait]		= sys_wait,
	[SYS_read]		= sys_read,
	[SYS_getpid]	= sys_getpid,
	[SYS_exit]		= sys_exit,
	[SYS_kill]		= sys_kill,
};

void syscall(void)
{
	int num;
	struct proc *p; /* = myproc();*/

	num = p->trapframe->a7;
	if (num > 0 && num < NOE(syscalls) && syscalls[num]) {
		p->trapframe->a0 = syscalls[num]();
	} else {
		/* unknown syscall */
	}
}
