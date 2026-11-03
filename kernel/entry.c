#include <stdint.h>

#include "include/proc.h"
#include "../user/uart.h"
#include "../user/blink.h"

#define STACK_SIZE 4096
uint8_t proc0_kstack[STACK_SIZE] __attribute__((aligned(16)));

struct proc proc_table[10];
struct cpu cpu0;

extern uint32_t __bss_start[]; /* NOLINT */
extern uint32_t __bss_end[];   /* NOLINT */

#define RISCV_MTVEC_MODE_VECTORED 1

/* WATCHDOG registers */
#define TIMG0_WDTCONFIG0_REG      ((volatile uint32_t *)0x6001F048)
#define TIMG0_WDTWPROTECT_REG     ((volatile uint32_t *)0x6001F064)
#define RTC_CNTL_WDTCONFIG0_REG   ((volatile uint32_t *)0x60008098)
#define RTC_CNTL_WDTWPROTECT_REG  ((volatile uint32_t *)0x600080A4)
#define RTC_CNTL_SWD_CONF_REG     ((volatile uint32_t *)0x600080B4)
#define RTC_CNTL_SWD_WPROTECT_REG ((volatile uint32_t *)0x600080B8)

void
delay_ms(uint32_t ms)
{
    volatile uint32_t count = ms * 150000;

    while (count--) {
        asm volatile("nop" : : : "memory");
    }
}

extern void pop_trapframe(struct trapframe *tf);
extern void trap_vector(void);

void
trap_handler()
{
    struct proc *p = cpu0.proc;
    if (!p) {
#if 0
        *SYSTIMER_CONF_REG &= ~(1 << 29);
#endif
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
        uart_putchar('1');
        break;
    case 0x2:
        /* Illegal Instruction */
        uart_putchar('2');
        break;
    case 0x3:
        /* Hardware Breakpoint/Watchpoint or EBREAK */
        uart_putchar('3');
        break;
    case 0x5:
        /* PMP Load access fault */
        uart_putchar('5');
        break;
    case 0x7:
        /* PMP Store access fault */
        uart_putchar('7');
        break;
    case 0x8:
        /* ECALL from U mode */
        uart_putchar('8');
        break;
    case 0xb:
        /* ECALL from M mode */
        uart_putchar('b');
        break;
    default:
        /* Unknown process */
        uart_putchar('u');
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

extern void mtvec_table(void);

void
init_trap_handling(void)
{
    /* vectored interrupts enable */
    asm volatile("csrw mtvec, %0"
                 :
                 : "r"((uintptr_t)mtvec_table | RISCV_MTVEC_MODE_VECTORED));
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

void
mtvec_mei(void)
{
    uart_putchar('m');
    uart_putchar('e');
    uart_putchar('i');
}

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
     * In our case it is needed to return processor to M-mode after mret
     *
     * MPIE - "Machine Previous Interrupt Enable"
     * mpie 1t bit to 1 (after mret puts value from mpie to mie)
     * In our case it is guarantees that global interrupts will
     * enable after mret
     *
     * MIE - "Machine Interrupt Enable"
     * mie 3d bit to 1 (manage the processor interrupt management)
     * In our case it is needed to enable global interrupts
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

    init_first_process();

    struct proc *p = &proc_table[0];

    pop_trapframe(&p->trapframe);

    while (1)
        ;
}
