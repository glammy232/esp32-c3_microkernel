#define uint32_t unsigned int

// Адреса регистров управления Watchdog (Таймеры и RTC)
#define TIMG0_BASE              0x6001F000
#define TIMG0_WDTCONFIG0_REG    (TIMG0_BASE + 0x0048)
#define TIMG0_WDTWPROTECT_REG   (TIMG0_BASE + 0x0064)

#define RTC_CNTL_BASE           0x60008000
#define RTC_CNTL_WDTCONFIG0_REG (RTC_CNTL_BASE + 0x008C)
#define RTC_CNTL_WDTWPROTECT_REG (RTC_CNTL_BASE + 0x00A8)

// Магические ключи для снятия защиты от записи в регистры вочдогов
#define TIMG_WDT_WKEY_VALUE     0x50D83AA1
#define RTC_WDT_WKEY_VALUE      0x50D83AA1

void disable_watchdogs(void) {
    // 1. Отключаем Watchdog в Timer Group 0
    *(volatile uint32_t *)TIMG0_WDTWPROTECT_REG = TIMG_WDT_WKEY_VALUE; // Снимаем защиту
    *(volatile uint32_t *)TIMG0_WDTCONFIG0_REG = 0;                    // Обнуляем конфигурацию (отключаем)
    *(volatile uint32_t *)TIMG0_WDTWPROTECT_REG = 0;                    // Возвращаем защиту

    // 2. Отключаем RTC Watchdog
    *(volatile uint32_t *)RTC_CNTL_WDTWPROTECT_REG = RTC_WDT_WKEY_VALUE; // Снимаем защиту
    *(volatile uint32_t *)RTC_CNTL_WDTCONFIG0_REG = 0;                    // Отключаем
    *(volatile uint32_t *)RTC_CNTL_WDTWPROTECT_REG = 0;                    // Возвращаем защиту
}

// Структура для сохранения контекста процессора (соответствует нашему ассемблеру)
struct trap_frame {
    uint32_t regs[32]; // regs[1] = ra, regs[2] = sp, и т.д.
};

// Сюда мы прилетаем при любом ecall или прерывании
void kernel_trap_handler(uint32_t mcause, uint32_t mepc, struct trap_frame *frame) {
    // Исключение номер 8 — это ecall из U-mode (пользовательский системный вызов)
    if (mcause == 8) {
        // Системный вызов!
        // Номер системного вызова обычно передают в регистре a7 (regs[17])
        uint32_t syscall_num = frame->regs[17];
        
        // Обработка системного вызова...
        
        // ВАЖНО: нужно сдвинуть mepc на 4 байта вперед, 
        // иначе mret вернет процессор на ту же инструкцию ecall, и мы зациклимся
        __asm__ volatile("csrw mepc, %0" :: "r"(mepc + 4));
    } else {
        // Какое-то другое исключение (например, ошибка PMP или деление на ноль)
        // В реальном микроядре здесь мы должны "убить" упавший процесс
        while(1); 
    }
}

// Entry point where program jumps after boot.S
void kernel_init(void) {
    disable_watchdogs();

    // Тут ваше ядро оживает! 
    // Можно инициализировать UART для отладочного вывода printf
    
    // Переходим к планировщику или первой задаче
    while (1) {
        __asm__ volatile("wfi"); // Ждем прерываний (Sleep mode)
    }
}

