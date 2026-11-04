#include "kernel/types.h"
#include "kernel/trap.h"
#include "kernel/timer.h"
#include "kernel/scheduler.h"

extern uint32_t __bss_start[]; /* NOLINT */
extern uint32_t __bss_end[];   /* NOLINT */

int
mmain(void)
{
    /* clean bss section */
    uintptr_t end_addr = (uintptr_t)__bss_end;
    for (uint32_t *dest = (uint32_t *)__bss_start; (uintptr_t)dest < end_addr;
         dest++) {
        *dest = 0;
    }

    preinit_scheduler();

    init_trap_handling();

    init_extsystimer();

    init_scheduler();

    while (1)
        ;
}
