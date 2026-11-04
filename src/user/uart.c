#include <stdint.h>

#define UART0_FIFO_REG    ((volatile uint32_t *)0x60000000)
#define UART0_STATUS_REG  ((volatile uint32_t *)0x6000001C)
#define UART_TXFIFO_CNT_M (0x000003FF)

#define UART0_CLKDIV_REG       ((volatile uint32_t *)0x60000014)
#define UART_CLKDIV_115200_40M (0x15B3)
#define UART0_CONF0_REG        ((volatile uint32_t *)0x60000020)

void
init_uart(void)
{
    *UART0_CLKDIV_REG = UART_CLKDIV_115200_40M;

    uint32_t conf0 = 0;
    conf0 |= (3 << 2);
    conf0 |= (1 << 4);
    *UART0_CONF0_REG = conf0;

    *UART0_CONF0_REG |= (1 << 18);
    *UART0_CONF0_REG |= (1 << 19);
    *UART0_CONF0_REG &= ~((1 << 18) | (1 << 19));
}

void
uart_putchar(char c)
{
#if 1
    while (((*UART0_STATUS_REG) & UART_TXFIFO_CNT_M) >= 126)
        ;

    *UART0_FIFO_REG = (uint32_t)c;
#endif
}

void
uart_print(const char *s)
{
    /*while (*s != '\0') {
        uart_putchar(*s);
        s++;
    }*/
    uart_putchar('\r');
    uart_putchar('\n');
}
