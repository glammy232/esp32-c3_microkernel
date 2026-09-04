#include "desc.h"

void riscv_enable_interrupts(void)
{
	uint32_t mie_mask = (1 << 11);
	asm volatile("csrs mie, %0" :: "r"(mie_mask));

	uint32_t mstatus_mask = (1 << 3);
	asm volatile("csrs mstatus, %0" :: "r"(mstatus_mask));
}
