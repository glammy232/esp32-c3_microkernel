.section .init, "ax"
.global _start
_start:
	# 1. Disable interrupts globally
	csrci mstatus, 0x8

	# 2. Initialize stack pointer
	# stack must be in sram
	la sp, _stack_top

	# 3. Initialize global pointer to optimize linker
	.option push
	.option norelax
	la gp, __global_pointer$
	.option pop

	# 4. Make .bss section zero
	la t0, _sbss
	la t1, _ebss
bss_loop:
	beq t0, t1, bss_done
	sw zero, 0(t0)
	addi t0, t0, 4
	j bss_loop
bss_done:
	# 5. Set PMP
	csrw pmpcfg0, zero
	# TODO - set regions to kernel security

	# 6. Set interrupt vector table
	la t0, default_trap_vector
	# Little two bits are 00 (Direct mode)
	csrw mtvec, t0

	# 7. Jump to C code
	jal zero, kernel_init

### mtvec setting
.section .vectors, "ax"
.global default_trap_vector
.align 4 /* Адрес mtvec ОБЯЗАТЕЛЬНО должен быть выровнен по 4 байтам */

default_trap_vector:
	# 1. Save user registers.
	# Так как оригинальный стек U-mode трогать нельзя (он изолирован PMP),
	# ядро должно временно использовать специальный скретч-регистр mscratch,
	# где заранее (при переключении на задачу) был сохранен указатель на стек ядра.
    
	csrrw sp, mscratch, sp  # Обмениваем SP задачи и SP ядра местами. 
                            # Теперь SP указывает на стек ядра, а в mscratch лежит SP задачи.

	# Выделяем место на стеке ядра для сохранения контекста задачи (32 регистра)
	addi sp, sp, -128
	sw x1,  4(sp)
	sw x3,  12c(sp)         # Пропускаем x2 (SP), его сохраним отдельно
	sw x4,  16(sp)
	# ... сохраняем регистры с x5 по x31 ...
    
	# Достаем оригинальный SP задачи из mscratch и сохраняем на стек ядра
	csrr t0, mscratch
	sw t0,  8(sp)           # x2 (SP задачи) сохранен в структуру контекста

	# Шаг 2: Читаем причину прерывания/исключения
	csrr a0, mcause         # Первый аргумент для Си-функции (причина)
	csrr a1, mepc           # Второй аргумент (адрес инструкции, вызвавшей прерывание)
	mv   a2, sp             # Третий аргумент (указатель на сохраненный контекст)

	# Шаг 3: Вызываем обработчик на Си/Rust
	# Наше микроядро проверит mcause. Если mcause == 8, это ecall из U-mode (системный вызов)
	jal ra, kernel_trap_handler

	# Шаг 4: Возвращаем контекст (после работы планировщика или системного вызова)
	# (Перед этим Си-код запишет в mepc адрес следующей инструкции: mepc + 4, чтобы не зациклиться на ecall)
    
	lw t0, 8(sp)            # Восстанавливаем SP задачи во временный регистр
	csrw mscratch, t0       # Кладем его в mscratch

	lw x1, 4(sp)
	# ... восстанавливаем остальные регистры с x3 по x31 ...
    
	addi sp, sp, 128        # Освобождаем стек ядра
	csrrw sp, mscratch, sp  # Возвращаем SP задачи на место, а SP ядра прячем в mscratch

	# Шаг 5: Возврат в пользовательский режим
	mret
