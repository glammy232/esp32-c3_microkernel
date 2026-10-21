#include <stdint.h>

#include "proc.h"

#define SYSTIMER_CONF_REG ((volatile uint32_t *)0x60023000)
#define SYSTIMER_INT_CLR_REG ((volatile uint32_t *)0x60023014)

extern void uart_println(char *str);

extern void swtch();

volatile uint32_t ticks_count = 0;

void trap_handler()
{
	struct proc *p = cpu0.proc;

	if (!p) {
		*SYSTIMER_CONF_REG &= ~(1 << 29);
		// uart_print("[KERNEL] ERROR: cpu0.proc is NULL!");
		while (1)
			;
	}

	uint32_t mcause = p->trapframe.mcause;

	if (mcause & (1 << 31)) {
		*SYSTIMER_INT_CLR_REG = (1 << 0);
		ticks_count++;

		// if (ticks_count % 10 == 0)
		// uart_print("[KERNEL] System Tick!");
		// swtch(&p->context, &cpu0.context);

		// p->state = RUNNING;
	} else {
		// uart_print("[KERNEL] FATAL: CPU Exception. mcause = ");

		/*char hex[9];
		uint32_t val = mcause;
		for (int i = 7; i >= 0; i--) {
			int digit = val & 0xF;
			hex[i] = digit < 10 ? '0' + digit : 'A' + (digit - 10);
			val >>= 4;
		}
		hex[8] = '\0';
		uart_print(hex);
*/
		while (1)
			;
	}
}
