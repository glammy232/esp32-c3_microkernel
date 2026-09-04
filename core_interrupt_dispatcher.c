#include "desc.h"
#include "scheduler.h"
/*Регистр сброса прерываний*/
#define SYSTIMER_INT_CLR_REG	(*(volatile uint32_t *)(0x60023000 + 0x0044))

void core_interrupt_dispatcher(uint32_t mcause, uint32_t mepc)
{
	if ((mcause & 0x80000000) && ((mcause & 0x7FFFFFFF) == 11)) {
		SYSTIMER_INT_CLR_REG |= (1 << 0);
		schedule();
	} else {
		/*printf("KERNEL PANIC! Exception cause: 0x%X, epc: 0x%X\n", mcause, mepc);*/
		while (1);
	}
}
