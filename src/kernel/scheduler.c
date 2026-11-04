#include "kernel/types.h"
#include "kernel/proc.h"
#include "user/blink.h"
#include "user/uart.h"
#include "user/say.h"

#define MAX_PROC_LIFE 100 /* systimer ticks */

#define STACK_SIZE 4096
#define MAX_PROCS  3

uint8_t procs_kstack[MAX_PROCS][STACK_SIZE] __attribute__((aligned(16)));
struct proc proc_table[MAX_PROCS];
struct cpu cpu0;

extern void pop_trapframe(struct trapframe *tf);
extern void trap_vector(void);
extern void swtch(struct context *old, struct context *new);

int proc_index = 1;

void
init_process(void *f)
{
    struct proc *p = &proc_table[proc_index - 1];
    p->pid = proc_index;
    p->state = READY;

    uint32_t kstack_top = (uint32_t)&procs_kstack[proc_index - 1][STACK_SIZE];
    p->kstack = kstack_top;

    p->trapframe.mepc = (uint32_t)f;
    p->trapframe.mstatus = (3 << 11) | (1 << 7) | (1 << 3);

    p->context.ra = (uint32_t)pop_trapframe;
    p->context.sp = (uint32_t)kstack_top;

    proc_index++;
}

void
init_process_strparam(void (*f)(const char *), const char *s)
{
    struct proc *p = &proc_table[proc_index - 1];
    p->pid = proc_index;
    p->state = READY;

    uint32_t kstack_top = (uint32_t)&procs_kstack[proc_index - 1][STACK_SIZE];
    p->kstack = kstack_top;

#if 0
    uint32_t sp = (kstack_top - sizeof(struct trapframe)) & ~0xF;
    struct trapframe *tf = (struct trapframe *)sp;

    tf->mepc = (uint32_t)f;
    tf->mstatus = (3 << 11) | (1 << 7) | (1 << 3);
    tf->a0 = (uint32_t)s;
#endif

    p->trapframe.mepc = (uint32_t)f;
    p->trapframe.a0 = (uint32_t)s;
    p->trapframe.mstatus = (3 << 11) | (1 << 7) | (1 << 3);

    p->context.ra = (uint32_t)pop_trapframe;
    p->context.sp = (uint32_t)kstack_top;

    proc_index++;
}

void
schedule()
{
    struct proc *p = cpu0.proc;
    p->state = READY;
    swtch(&p->context, &cpu0.context);
}

void
preinit_scheduler(void)
{
    init_process_strparam(say, "hello");
    struct proc *p = &proc_table[0];
    cpu0.proc = p;
    asm volatile("csrw mscratch, %0" : : "r"(&p->trapframe));
}

void
init_scheduler(void)
{
    init_process(blink);
    init_process_strparam(say, "world");

    for (;;) {
        for (int i = 0; i < MAX_PROCS; i++) {
            struct proc *p = &proc_table[i];

            if (p->state == READY) {
                p->state = RUNNING;
                cpu0.proc = p;
                asm volatile("csrw mscratch, %0" : : "r"(&p->trapframe));

                swtch(&cpu0.context, &p->context);
            }
        }
    }
}
