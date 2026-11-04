#include "kernel/types.h"
#include "kernel/proc.h"
#include "user/uart.h"
#include "kernel/scheduler.h"

#define RISCV_MTVEC_MODE_VECTORED 1

#define INTERRUPT_CORE0_CPU_INT_STATUS_REG ((volatile uint32_t *)0x600C2044)
#define SYSTIMER_INT_CLR_REG               ((volatile uint32_t *)0x60023014)

extern void mtvec_table(void);
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
                    schedule();
                }
                p->trapframe.mstatus |= (1 << 7);
                return p ? &p->trapframe : 0;
            }
        }
        p->trapframe.mstatus |= (1 << 7);
        return p ? &p->trapframe : 0;
    }

    uint32_t exception_code = mcause & 0x1F;

    if (exception_code == 1) {         /* PMP Instruction access fault */
    } else if (exception_code == 2) {  /* Illegal Instruction */
    } else if (exception_code == 3) {  /* EBREAK */
    } else if (exception_code == 5) {  /* PMP Load access fault */
    } else if (exception_code == 7) {  /* PMP Store access fault */
    } else if (exception_code == 8) {  /* ECALL from U mode */
    } else if (exception_code == 11) { /* ECALL from M mode */
    } else {                           /* Unknown exception */
    }

    p->trapframe.mstatus |= (1 << 7);
    return p ? &p->trapframe : 0;
}

void
init_trap_handling(void)
{
    /* vectored interrupts enable */
    asm volatile("csrw mtvec, %0"
                 :
                 : "r"((uintptr_t)mtvec_table | RISCV_MTVEC_MODE_VECTORED));
    asm volatile("csrw mie, zero");
    asm volatile("csrw mip, zero");

#if 0
    struct proc *p = cpu0.proc;
    if (p) {
        asm volatile("csrw mscratch, %0" : : "r"(&p->trapframe));
    }
#endif
}

void
mtvec_exception(void)
{
    trap_handler();
}

void
mtvec_ssi(void)
{
}

void
mtvec_msi(void)
{
}

void
mtvec_sti(void)
{
}

void
mtvec_mti(void)
{
}

void
mtvec_sei(void)
{
}

void __attribute__((interrupt))
mtvec_mei(void)
{

    trap_handler();
}
