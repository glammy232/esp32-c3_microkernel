#include "timer.h"
#include "kernel.h"
#include "connect_timer_to_cpu.h"
#include "scheduler.h"
#include "tcb.h"

#define TIMG0_WDTCONFIG0_REG		((volatile unsigned int *)0x6001F048)
#define TIMG0_WDTWPROTECT_REG		((volatile unsigned int *)0x6001F064)

#define RTC_CNTL_WDTCONFIG0_REG		((volatile unsigned int *)0x60008098)
#define RTC_CNTL_WDTWPROTECT_REG	((volatile unsigned int *)0x600080A4)

#define GPIO_ENABLE_REG			((volatile unsigned int *)0x60004020)

#define GPIO_OUT_W1TS_REG		((volatile unsigned int *)0x60004008)
#define GPIO_OUT_W1TC_REG		((volatile unsigned int *)0x6000400C)

#define UART0_FIFO_REG			((volatile unsigned int *)0x60000000)
#define UART0_STATUS_REG		((volatile unsigned int *)0x6000001C)
#define UART_TXFIFO_CNT_M		(0x000000FF)

extern volatile TCB *current_tcb;
extern volatile uint32_t current_task_index;

void uart_putchar(char c)
{
	while (((*UART0_STATUS_REG) & UART_TXFIFO_CNT_M) >= 126);

	*UART0_FIFO_REG = (unsigned int)c;
}

/*void blink(void)
{
	*GPIO_ENABLE_REG |= (1 << 8);

	while (1) {
		*GPIO_OUT_W1TC_REG = (1 << 8);

		uart_putchar('O');
		uart_putchar('N');
		uart_putchar('\n');

		for (volatile int i = 0; i < 4000000; i++);

		*GPIO_OUT_W1TS_REG = (1 << 8);
		
		uart_putchar('O');
		uart_putchar('F');
		uart_putchar('F');

		for (volatile int i = 0; i < 4000000; i++);
	}
}*/

void task_one(void)
{
	while (1) {
		*GPIO_ENABLE_REG |= (1 << 8);
	
		uart_putchar('O');
		uart_putchar('N');
		uart_putchar('\n');

		for (volatile int i = 0; i < 500000; i++);
	}
}

void task_two(void)
{
	while (1) {
		*GPIO_ENABLE_REG |= (1 << 8);
	
		uart_putchar('O');
		uart_putchar('F');
		uart_putchar('F');
		uart_putchar('\n');

		for (volatile int i = 0; i < 500000; i++);
	}
}

int main(void)
{
	*TIMG0_WDTWPROTECT_REG = 0x50D83AA1;
	*TIMG0_WDTCONFIG0_REG = 0;
	*TIMG0_WDTWPROTECT_REG = 0;

	*RTC_CNTL_WDTWPROTECT_REG = 0x50D83AA1;
	*RTC_CNTL_WDTCONFIG0_REG = 0;
	*RTC_CNTL_WDTWPROTECT_REG = 0;

	task_create(task_one);
	task_create(task_two);

	systimer_init(10);
	interrupt_matrix_init();

	current_task_index = 0;
	current_tcb = &task_table[0];

	riscv_enable_interrupts();

	asm volatile(
        	"mv sp, %0\n"           // Загружаем sp Задачи 0 в реальный sp процессора
        	"j exception_handler\n" // Перепрыгиваем в конец обработчика (он сделает RESTORE и mret)
        	:: "r"(current_tcb->stack_ptr)
    );

	while (1) {

	}
}
