#include <stdint.h>

/* Interrupt Matix */
#define INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG                          \
    ((volatile uint32_t *)0x600C209C)
#define INTERRUPT_CORE0_CPU_INT_ENABLE_REG ((volatile uint32_t *)0x600C2000)

/* Systimer registers */
#define SYSTIMER_TARGET0_HI_REG ((volatile uint32_t *)0x60023030)
#define SYSTIMER_TARGET0_LO_REG ((volatile uint32_t *)0x60023034)
#define SYSTIMER_COMP0_LOAD_REG ((volatile uint32_t *)0x60023038)
#define SYSTIMER_CONF_REG       ((volatile uint32_t *)0x60023000)
#define SYSTIMER_INT_CLR_REG    ((volatile uint32_t *)0x60023014)

void
init_extsystimer(void)
{
    /* 160 000 ticks, 16mgc by XTAL = 10ms */
    uint32_t delay = 160000;

    /* direct Systimer Target 0 to CPU Interrupt 7 line */
    *INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG = 7;

    /* give access to CPU Interrupt 7 line in interrupt controller */
    *INTERRUPT_CORE0_CPU_INT_ENABLE_REG |= (1 << 7);

    /* setting comparator timer */
    *SYSTIMER_TARGET0_LO_REG = delay;
    *SYSTIMER_TARGET0_HI_REG = 0;

    /**
     * setting CONF_REG:
     * bit 30 = compare mode (0 - absolute time, 1 -
     * period)
     * bit 29 = enable comparator 0
     */
    *SYSTIMER_CONF_REG |= (1 << 30) | (1 << 29);

    /* enable comparator settings */
    *SYSTIMER_COMP0_LOAD_REG = 1;

    /* reset interrupt flag */
    *SYSTIMER_INT_CLR_REG = (1 << 0);

    /**
     * give access to external interrupts only(Systimer generate external
     * interrupts
     */
    asm volatile("csrw mie, %0" : : "r"(1 << 11));

    asm volatile("csrw mstatus, %0" : : "r"(1 << 3));
}
