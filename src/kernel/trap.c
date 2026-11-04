#include "kernel/types.h"
#include "kernel/proc.h"
#include "user/uart.h"

#define RISCV_MTVEC_MODE_VECTORED 1

#define INTERRUPT_CORE0_CPU_INT_STATUS_REG ((volatile uint32_t *)0x600C2044)
#define SYSTIMER_INT_CLR_REG               ((volatile uint32_t *)0x60023014)

extern void mtvec_table(void);
extern void swtch(struct context *old, struct context *new);
volatile uint32_t ticks_cnt;

struct trapframe *
trap_handler()
{
    struct proc *p = cpu0.proc;
    if (!p) {
        while (1)
            ;
    }

    uint32_t mcause;
    asm volatile("csrr %0, mcause" : "=r"(mcause));
    if (mcause & (1U << 31)) {
        uint32_t irq_id = mcause & 0x1F;
        if (irq_id == 1 || irq_id == 7 || irq_id == 11) {
            uint32_t int_status = *INTERRUPT_CORE0_CPU_INT_STATUS_REG;
            if (int_status & (1 << 7)) {
                *SYSTIMER_INT_CLR_REG = (1 << 0);
                ticks_cnt++;

                if (ticks_cnt % 10 == 0) {
                    uart_putchar('T');
                }
#if 0
                swtch(&p->context, &p->context);
#endif
                p->state = RUNNING;
                return p ? &p->trapframe : 0;
            }
        }
        return p ? &p->trapframe : 0;
    }

    uint32_t exception_code = mcause & 0x1F;

    if (exception_code == 1) { /* PMP Instruction access fault */
        uart_putchar('1');
    } else if (exception_code == 2) { /* Illegal Instruction */
        uart_putchar('2');
    } else if (exception_code == 3) { /* EBREAK */
        uart_putchar('3');
    } else if (exception_code == 5) { /* PMP Load access fault */
        uart_putchar('5');
    } else if (exception_code == 7) { /* PMP Store access fault */
        uart_putchar('7');
    } else if (exception_code == 8) { /* ECALL from U mode */
        uart_putchar('8');
    } else if (exception_code == 11) { /* ECALL from M mode */
        uart_putchar('b');
    } else { /* Unknown exception */
        uart_putchar('u');
    }

    return &p->trapframe;

#if 0
        *SYSTIMER_INT_CLR_REG = (1 << 0);
        ticks_count++;
		if (ticks_count % 10 == 0)
		uart_print("[KERNEL] System Tick!");
		swtch(&p->context, &cpu0.context);

		p->state = RUNNING;
#endif
}

void
init_trap_handling(void)
{
    /* vectored interrupts enable */
    asm volatile("csrw mtvec, %0"
                 :
                 : "r"((uintptr_t)mtvec_table | RISCV_MTVEC_MODE_VECTORED));

    struct proc *p = cpu0.proc;
    if (p) {
        asm volatile("csrw mscratch, %0" : : "r"(&p->trapframe));
    }
}

void
mtvec_exception(void)
{
    uart_putchar('e');
    uart_putchar('x');
    uart_putchar('c');

    trap_handler();
}

void
mtvec_ssi(void)
{
    uart_putchar('s');
    uart_putchar('s');
    uart_putchar('i');
}

void
mtvec_msi(void)
{
    uart_putchar('m');
    uart_putchar('s');
    uart_putchar('i');
}

void
mtvec_sti(void)
{
    uart_putchar('s');
    uart_putchar('t');
    uart_putchar('i');
}

void
mtvec_mti(void)
{
    uart_putchar('m');
    uart_putchar('t');
    uart_putchar('i');
}

void
mtvec_sei(void)
{
    uart_putchar('s');
    uart_putchar('e');
    uart_putchar('i');
}

void __attribute__((interrupt))
mtvec_mei(void)
{
    uart_print("mei\0");

    trap_handler();
}
