#include "user/uart.h"
#include "kernel/types.h"

void
say(const char *s)
{
    size_t cnt = 0;
    while (1) {
        uart_print(s);
        cnt++;
    }
    uart_putchar((char)cnt);
}
