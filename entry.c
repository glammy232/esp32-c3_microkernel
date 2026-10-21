#if 1
#include <stdint.h>

#include "proc.h"

#define STACK_SIZE 4096
uint8_t proc0_kstack[STACK_SIZE] __attribute__((aligned(16)));

struct proc proc_table[10];
struct cpu cpu0;

extern uint32_t __bss_start[];
extern uint32_t __bss_end[];

/* SYSTIMER (ESP32-C3) */
#define SYSTIMER_TARGET0_HI_REG ((volatile uint32_t *)0x60023030)
#define SYSTIMER_TARGET0_LO_REG ((volatile uint32_t *)0x60023034)
#define SYSTIMER_COMP0_LOAD_REG ((volatile uint32_t *)0x60023038)
#define SYSTIMER_CONF_REG ((volatile uint32_t *)0x60023000)

#define SYSTIMER_INT_CLR_REG ((volatile uint32_t *)0x60023014)

/* routing register */
#define INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG \
	((volatile uint32_t *)0x600C209C)

/* processor interupt registers. Machine Timer Interrupt */
#define INTERRUPT_CORE0_CPU_INT_ENABLE_REG ((volatile uint32_t *)0x600C2000)

/* WATCHDOG registers */
#define TIMG0_WDTCONFIG0_REG ((volatile uint32_t *)0x6001F048)
#define TIMG0_WDTWPROTECT_REG ((volatile uint32_t *)0x6001F064)
#define RTC_CNTL_WDTCONFIG0_REG ((volatile uint32_t *)0x60008098)
#define RTC_CNTL_WDTWPROTECT_REG ((volatile uint32_t *)0x600080A4)
#define RTC_CNTL_SWD_CONF_REG ((volatile uint32_t *)0x600080B4)
#define RTC_CNTL_SWD_WPROTECT_REG ((volatile uint32_t *)0x600080B8)

/* io_mux, gpio registers */
#define IO_MUX_GPIO8_REG ((volatile uint32_t *)0x60009024)
#define GPIO_ENABLE_REG ((volatile uint32_t *)0x60004020)
#define GPIO_OUT_W1TS_REG ((volatile uint32_t *)0x60004008)
#define GPIO_OUT_W1TC_REG ((volatile uint32_t *)0x6000400C)

#define LED_PIN 8

/* UART0 */
#define UART0_FIFO_REG ((volatile uint32_t *)0x60000000)
#define UART0_STATUS_REG ((volatile uint32_t *)0x6000001C)
#define UART_TXFIFO_CNT_M (0x000003FF)

#define UART0_CLKDIV_REG ((volatile uint32_t *)0x60000014)
#define UART0_CONF0_REG ((volatile uint32_t *)0x60000020)
#define UART_CLKDIV_115200_40M (0x15B3)

void init_uart0(void)
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

void delay_ms(uint32_t ms)
{
	volatile uint32_t count = ms * 150000;

	while (count--) {
		asm volatile("nop" : : : "memory");
	}
}

void uart_putchar(char c)
{
	while (((*UART0_STATUS_REG) & UART_TXFIFO_CNT_M) >= 126)
		;

	*UART0_FIFO_REG = (uint32_t)c;
}

#if 0
void uart_print(const char *str)
{
	while (*str)
		uart_putchar(*str++);
	uart_putchar('\r');
	uart_putchar('\n');
}
#endif

void init_hardware(void)
{
#if 0
	/* ---- 1. TIMG0 WDT ---- */
	*TIMG0_WDTWPROTECT_REG = 0x50D83AA1;
	*TIMG0_WDTCONFIG0_REG &=
		~((1u << 31) | (1u << 14)); // EN=0, FLASHBOOT_MOD_EN=0
	*TIMG0_WDTWPROTECT_REG = 0;

	/* ---- 2. RTC_CNTL_WDT ---- */
	*RTC_CNTL_WDTWPROTECT_REG = 0x50D83AA1;
	*RTC_CNTL_WDTCONFIG0_REG &= ~(1u << 31); // RTC_CNTL_WDT_EN = 0
	*RTC_CNTL_WDTWPROTECT_REG = 0;

	/* ---- 3. Super Watchdog (SWD) — ОТДЕЛЬНЫЙ КЛЮЧ! ---- */
	*RTC_CNTL_SWD_WPROTECT_REG = 0x8F1D312A; // <-- правильный ключ
	*RTC_CNTL_SWD_CONF_REG |= (1u << 30);	 // SWD_DISABLE = 1
	*RTC_CNTL_SWD_WPROTECT_REG = 0;
#endif

#if 1
	uint32_t reg_val = *IO_MUX_GPIO8_REG;
	reg_val &= ~((7 << 12) | (1 << 7) | (1 << 8));
	reg_val |= (1 << 12);
	*IO_MUX_GPIO8_REG = reg_val;
	*GPIO_ENABLE_REG |= (1 << LED_PIN);
#endif
}

void init_timer(void)
{
	uint32_t delay = 160000;

	*INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG = 7;

	/* connect Systimer to CPU Interrupt 7 */
	*INTERRUPT_CORE0_CPU_INT_ENABLE_REG |= (1 << 7);

	*SYSTIMER_INT_CLR_REG = (1 << 0);

	/* setting system timer comparator */
	*SYSTIMER_TARGET0_LO_REG = delay;
	*SYSTIMER_TARGET0_HI_REG = 0;

	/* bit 30 = ... mode; bit 29 = turn on comparator */
	*SYSTIMER_CONF_REG |= (1 << 30) | (1 << 29);

	/* accept comparator settings */
	*SYSTIMER_COMP0_LOAD_REG = 1;

	*SYSTIMER_INT_CLR_REG = (1 << 0);

	uint32_t mie_flags = (1 << 7) | (1 << 11) | (1 << 3);
	asm volatile("csrs mie, %0" : : "r"(mie_flags));

	// asm volatile("csrs mie, %0" : : "r"(1 << 7));
}

extern void machine_pop_trapframe(struct trapframe *tf);
extern void trap_vector(void);

void blink_proc(void)
{
	while (1) {
		*GPIO_OUT_W1TC_REG = (1 << LED_PIN);
		uart_putchar('O');
		uart_putchar('N');
		uart_putchar('\n');
		delay_ms(500);

		*GPIO_OUT_W1TS_REG = (1 << LED_PIN);
		uart_putchar('O');
		uart_putchar('F');
		delay_ms(500);
	}
}

void init_trap_handling(void)
{
	/**
	 * Записываем адрес trap_vector в системный регистр mtvec.
	 * Последние 2 бита регистра mtvec отвечают за режим
	 * (00 = Direct, все прерывания прыгают в одну точку)
	 */
	uint32_t vector_address = (uint32_t)trap_vector & ~0x3;

	asm volatile("csrw mtvec, %0" : : "r"(vector_address));
}

void init_first_process(void)
{
	struct proc *p = &proc_table[0];

	p->pid = 1;
	p->state = READY;

	uint32_t kstack_top = (uint32_t)proc0_kstack + STACK_SIZE;
	p->kstack = kstack_top;

	/* where we return after mk initialization */
	p->trapframe.mepc = (uint32_t)blink_proc;

	/* mstatus initialization */
	/* mpie = 1 (get access to interrupts after mret */
	/* mpp = 11 (machine-mode) */
	p->trapframe.mstatus = (3 << 11) | (1 << 7) | (1 << 3);

	/* setting context for scheduler */
	/* when the scheduler do swtch(), it jumps to context.ra */
	p->context.ra = (uint32_t)machine_pop_trapframe;

	/* processor will read data from trapframe firstly */
	p->context.sp = (uint32_t)&p->trapframe;

	cpu0.proc = p;
}

int mmain(void)
{
	for (uint32_t *dest = (uint32_t *)__bss_end;
	     dest < (uint32_t *)__bss_start;) {
		*dest++ = 0;
	}

	init_hardware();

	init_uart0();

	init_trap_handling();

	init_first_process();

	// init_timer();

	struct proc *p = &proc_table[0];

	machine_pop_trapframe(&p->trapframe);

	while (1)
		;
}
#endif

#if 0
#define TIMG0_WDTCONFIG0_REG ((volatile unsigned int *)0x6001F048)
#define TIMG0_WDTWPROTECT_REG ((volatile unsigned int *)0x6001F064)

#define RTC_CNTL_WDTCONFIG0_REG ((volatile unsigned int *)0x60008098)
#define RTC_CNTL_WDTWPROTECT_REG ((volatile unsigned int *)0x600080A4)

#define GPIO_ENABLE_REG ((volatile unsigned int *)0x60004020)

#define GPIO_OUT_W1TS_REG ((volatile unsigned int *)0x60004008)
#define GPIO_OUT_W1TC_REG ((volatile unsigned int *)0x6000400C)

#define UART0_FIFO_REG ((volatile unsigned int *)0x60000000)
#define UART0_STATUS_REG ((volatile unsigned int *)0x6000001C)
#define UART_TXFIFO_CNT_M (0x000000FF)

void uart_putchar(char c)
{
	while (((*UART0_STATUS_REG) & UART_TXFIFO_CNT_M) >= 126)
		;

	*UART0_FIFO_REG = (unsigned int)c;
}

void blink(void)
{
	*GPIO_ENABLE_REG |= (1 << 8);

	while (1) {
		*GPIO_OUT_W1TC_REG = (1 << 8);

		uart_putchar('O');
		uart_putchar('N');
		uart_putchar('\n');

		for (volatile int i = 0; i < 4000000; i++)
			;

		*GPIO_OUT_W1TS_REG = (1 << 8);

		uart_putchar('O');
		uart_putchar('F');
		uart_putchar('F');

		for (volatile int i = 0; i < 4000000; i++)
			;
	}
}

int mmain(void)
{
	*TIMG0_WDTWPROTECT_REG = 0x50D83AA1;
	*TIMG0_WDTCONFIG0_REG = 0;
	*TIMG0_WDTWPROTECT_REG = 0;

	*RTC_CNTL_WDTWPROTECT_REG = 0x50D83AA1;
	*RTC_CNTL_WDTCONFIG0_REG = 0;
	*RTC_CNTL_WDTWPROTECT_REG = 0;

	blink();
}
#endif
