#include <stdint.h>

#define INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG                          \
    ((volatile uint32_t *)0x600C209C)
#define INTERRUPT_CORE0_CPU_INT_ENABLE_REG ((volatile uint32_t *)0x600C2000)

#define SYSTIMER_TARGET0_HI_REG ((volatile uint32_t *)0x60023030)
#define SYSTIMER_TARGET0_LO_REG ((volatile uint32_t *)0x60023034)
#define SYSTIMER_COMP0_LOAD_REG ((volatile uint32_t *)0x60023038)
#define SYSTIMER_CONF_REG       ((volatile uint32_t *)0x60023000)
#define SYSTIMER_INT_CLR_REG    ((volatile uint32_t *)0x60023014)

void
init_timer(void)
{
    uint32_t delay = 160000;

    *INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG = 7;

    /* connect Systimer to CPU Interrupt 7 */
    *INTERRUPT_CORE0_CPU_INT_ENABLE_REG |= (1 << 7);

    *SYSTIMER_INT_CLR_REG = (1 << 0);

    /* setting system timer comparator */
    *SYSTIMER_TARGET0_LO_REG = delay;
    *SYSTIMER_TARGET0_HI_REG = 0;

    /* bit 30 = ... mode; bit 29 = turn on the comparator */
    *SYSTIMER_CONF_REG |= (1 << 30) | (1 << 29);

    /* accept comparator settings */
    *SYSTIMER_COMP0_LOAD_REG = 1;

    *SYSTIMER_INT_CLR_REG = (1 << 0);

    uint32_t mie_flags = (1 << 7) | (1 << 11) | (1 << 3);
    asm volatile("csrs mie, %0" : : "r"(mie_flags));
}
