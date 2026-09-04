#include "desc.h"

#define SYSTIMER_BASE		0x60023000

#define SYSTIMER_CONF_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x0000))
#define SYSTIMER_TARGET0_HI_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x0024))
#define SYSTIMER_TARGET0_LO_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x0028))
#define SYSTIMER_COMP0_LOAD_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x0034))
#define SYSTIMER_INT_ENA_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x003C))
#define SYSTIMER_INT_CLR_REG	(*(volatile uint32_t *)(SYSTIMER_BASE + 0x0044))

#define SYSTIMER_TIMER_TARGET0_PERIOD_MODE	(1 << 30)
#define SYSTIMER_TARGET0_INT_ENA		(1 << 0)

void systimer_init(uint32_t period_ms)
{
	// 1. Вычисляем количество тиков (при частоте 16 МГц)
    	uint64_t ticks = (uint64_t)period_ms * 16000;

    	// 2. Сбрасываем конфигурацию компаратора 0 и включаем периодический режим
    	SYSTIMER_CONF_REG |= SYSTIMER_TIMER_TARGET0_PERIOD_MODE;

	// 3. Записываем 64-битное значение периода в регистры сравнения TARGET0
    	SYSTIMER_TARGET0_LO_REG = (uint32_t)(ticks & 0xFFFFFFFF);
    	SYSTIMER_TARGET0_HI_REG = (uint32_t)((ticks >> 32) & 0xFFFFFFFF);

    	// 4. Применяем настройки (стробируем загрузку)
    	SYSTIMER_COMP0_LOAD_REG = 1;

    	// 5. Разрешаем модулю таймера генерировать прерывание
    	SYSTIMER_INT_ENA_REG |= SYSTIMER_TARGET0_INT_ENA;
}
