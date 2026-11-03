#include <stdint.h>

#include "proc.h"

#define SYSTIMER_CONF_REG    ((volatile uint32_t *)0x60023000)
#define SYSTIMER_INT_CLR_REG ((volatile uint32_t *)0x60023014)

extern void swtch();

volatile uint32_t ticks_count = 0;

void
trap_handler_test()
{
    struct proc *p = cpu0.proc;
    if (!p) {
        *SYSTIMER_CONF_REG &= ~(1 << 29);
        while (1)
            ;
    }

    uint32_t mcause = p->trapframe.mcause;
    if (mcause & (1U << 31)) {
        uint32_t irq_id = mcause & 0x1F;
        return;
    }

    switch (mcause) {
    case 0x1:
        /* PMP Instruction access fault */
        break;
    case 0x2:
        /* Illegal Instruction */
        break;
    case 0x3:
        /* Hardware Breakpoint/Watchpoint or EBREAK */
        break;
    case 0x5:
        /* PMP Load access fault */
        break;
    case 0x7:
        /* PMP Store access fault */
        break;
    case 0x8:
        /* ECALL from U mode */
        break;
    case 0xb:
        /* ECALL from M mode */
        break;
    default:
        /* Unknown process */
        break;
    }

#if 0
        *SYSTIMER_INT_CLR_REG = (1 << 0);
        ticks_count++;
		if (ticks_count % 10 == 0)
		uart_print("[KERNEL] System Tick!");
		swtch(&p->context, &cpu0.context);

		p->state = RUNNING;
#endif
}
