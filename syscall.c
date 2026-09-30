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
