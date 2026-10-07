#include <stdint.h>
#include "proc.h"

struct trapframe *usertrap(struct trapframe *tf)
{
	uint32_t cause;
	asm volatile("csrr %0, mcause" : "=r"(cause));
	
	if ((cause & 0x80000000) == 0) {
		uint32_t exception_code = cause & 0x1F;

		if (exception_code == 8) {
			uint32_t syscall_index = tf->a7;

			uint32_t mepc;
			asm volatile("csrr %0, mepc" : "=r"(mepc));
			mepc += 4;
			asm volatile("csrw mepc, %0" :: "r"(mepc));
		}
	} else {
	}
	return tf;
	/* userret(); */
}

