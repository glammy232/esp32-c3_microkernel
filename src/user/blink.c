#include "kernel/types.h"
#include "user/uart.h"

#define IO_MUX_GPIO8_REG  ((volatile uint32_t *)0x60009024)
#define GPIO_ENABLE_REG   ((volatile uint32_t *)0x60004020)
#define GPIO_OUT_W1TS_REG ((volatile uint32_t *)0x60004008)
#define GPIO_OUT_W1TC_REG ((volatile uint32_t *)0x6000400C)
#define LED_PIN           8

void
init_blink(void)
{
    uint32_t reg_val = *IO_MUX_GPIO8_REG;
    reg_val &= ~((7 << 12) | (1 << 7) | (1 << 8));
    reg_val |= (1 << 12);
    *IO_MUX_GPIO8_REG = reg_val;
    *GPIO_ENABLE_REG |= (1 << LED_PIN);
}

void
blink(void)
{
    while (1) {
        *GPIO_OUT_W1TC_REG = (1 << LED_PIN);
        uart_putchar('O');
        uart_putchar('N');
        uart_putchar('\n');

        *GPIO_OUT_W1TS_REG = (1 << LED_PIN);
        uart_putchar('O');
        uart_putchar('F');
        uart_putchar('\n');
    }
}
