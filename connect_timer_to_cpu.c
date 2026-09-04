#include "desc.h"

#define INTERRUPT_BASE              0x600C0000

// Регистр маппинга для периферийного прерывания №35 (SYSTIMER_TARGET0)
#define INT_MATRIX_SYSTIMER_TARGET0_REG (*(volatile uint32_t *)(INTERRUPT_BASE + (35 * 4)))

// Регистры настройки самих CPU прерываний (для CPU Interrupt 1)
#define CPU_INT_TYPE_REG            (*(volatile uint32_t *)(INTERRUPT_BASE + 0x0100))
#define CPU_INT_PRI_1_REG           (*(volatile uint32_t *)(INTERRUPT_BASE + 0x0118))
#define CPU_INT_ENABLE_REG          (*(volatile uint32_t *)(INTERRUPT_BASE + 0x0104))

void interrupt_matrix_init(void) {
    // 1. Привязываем физический источник №35 к CPU Interrupt line 1
    // Значение '1' в регистре источника означает перенаправление на CPU Int 1
    INT_MATRIX_SYSTIMER_TARGET0_REG = 1;

    // 2. Настраиваем тип CPU Interrupt 1: 0 - по уровню (level), 1 - по фронту (edge)
    // Таймер выдает прерывание по уровню, поэтому сбрасываем 1-й бит в 0
    CPU_INT_TYPE_REG &= ~(1 << 1);

    // 3. Задаем приоритет для CPU Interrupt 1 (от 1 до 15, где 15 — высший)
    CPU_INT_PRI_1_REG = 5; 

    // 4. Разрешаем обработку CPU Interrupt 1 на уровне матрицы прерываний
    CPU_INT_ENABLE_REG |= (1 << 1);
}
