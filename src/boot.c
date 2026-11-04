#include "kernel/types.h"
#include "kernel/proc.h"
#include "kernel/trap.h"
#include "kernel/timer.h"
#include "user/uart.h"
#include "user/blink.h"

#define STACK_SIZE 4096
uint8_t proc0_kstack[STACK_SIZE] __attribute__((aligned(16)));

struct proc proc_table[10];
struct cpu cpu0;

extern uint32_t __bss_start[]; /* NOLINT */
extern uint32_t __bss_end[];   /* NOLINT */

#define RISCV_MTVEC_MODE_VECTORED 1

extern void pop_trapframe(struct trapframe *tf);
extern void trap_vector(void);

void
init_first_process(void)
{
    struct proc *p = &proc_table[0];

    p->pid = 1;
    p->state = READY;

    uint32_t kstack_top = (uint32_t)proc0_kstack + STACK_SIZE;
    p->kstack = kstack_top;

    /* where we return after mk initialization */
    p->trapframe.mepc = (uint32_t)blink;

    /**
     * mstatus manage the processor working:
     *
     * MPP - "Machine Previous Privilege"
     * mpp 11th bit to 1 and 12th bit to 1 (save processor state before the
     * interrupt)
     * it is needed to return processor to M-mode after mret
     *
     * MPIE - "Machine Previous Interrupt Enable"
     * mpie 1t bit to 1 (after mret puts value from mpie to mie)
     * guarantees that global interrupts will
     * enable after mret
     *
     * MIE - "Machine Interrupt Enable"
     * mie 3d bit to 1 (enable global interrupts)
     */
    p->trapframe.mstatus = (3 << 11) | (1 << 7) | (1 << 3);

    /**
     * setting context for scheduler
     * when the scheduler call swtch(), it jumps to context.ra
     */
    p->context.ra = (uint32_t)pop_trapframe;

    /* processor will read data from trapframe firstly */
    p->context.sp = (uint32_t)&p->trapframe;

    cpu0.proc = p;
}

int
mmain(void)
{
    uintptr_t end_addr = (uintptr_t)__bss_start;
    for (uint32_t *dest = (uint32_t *)__bss_start; (uintptr_t)dest < end_addr;
         dest++) {
        *dest = 0;
    }

    init_trap_handling();

    init_extsystimer();

    init_first_process();

    struct proc *p = &proc_table[0];

    pop_trapframe(&p->trapframe);

    while (1)
        ;
}
