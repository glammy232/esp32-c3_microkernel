.section .init, "ax"
.global _start
.type _start, @function

_start:
	# reset kernel interruptions state
	csrw mie, zero		# disable kernel interruptions
	csrw mip, zero		# clear interrupt waiting flags

	# initialize pointers(stack and global pointer)
	.option push
	.option norelax
	la gp, __global_pointer$
	.option pop

	la sp, _stack_top
	# .option pop

	# setting address of interrupt/exception
	la t0, exception_handler
	# write address to mtvec (lower 2 bits = 00, direct state)
	csrw mtvec, t0
	# clear .bss section
	la t0, _bss_start
	la t1, _bss_end
	bge t0, t1, .L_bss_Done
.L_bss_Loop:
	sb zero, 0(t0)	# write 0 to t0 address
	addi t0, t0, 4	# 4 steps forward
	blt t0, t1, .L_bss_Loop
.L_bss_Done:
	# jump into main
	# mv s0, zero
	jal zero, main
.size _start, .-_start

.section .text
.global exception_handler
.align 4
exception_handler:
	# save all registers in the stack of interrupted task
	SAVE_CONTEXT

	# check - have we got an active task (kernel started or not)
    	la t0, current_tcb
    	lw t1, 0(t0)			# t1 = current_tcb
    	beqz t1, .L_skip_save_sp	# if NULL - an interrupt was before that scheduler had had start

    	# Сохраняем текущий указатель стека (sp) в поле stack_ptr нашей TCB структуры
    	sw sp, 0(t1)                # Поскольку stack_ptr первое поле, смещение равно 0

.L_skip_save_sp:
    	# 4. Вызываем обработчик на Си для очистки прерывания таймера и вызова планировщика
    	# Передаем mcause и mepc как аргументы функции (в регистры a0 и a1)
    	csrr a0, mcause
    	csrr a1, mepc
    	jal ra, core_interrupt_dispatcher

    	# 5. Диспетчер на Си мог изменить глобальную переменную current_tcb на другую задачу!
    	# Загружаем новый current_tcb
    	la t0, current_tcb
    	lw t1, 0(t0)                # t1 = новый current_tcb
    
    	# 6. Достаем сохраненный sp из новой TCB задачи
    	lw sp, 0(t1)                # sp = текущий стек новой задачи

    	# 7. Восстанавливаем состояние процессора для новой задачи
    	RESTORE_CONTEXT

    	# 8. Возвращаемся из прерывания. Процессор прыгнет по адресу mepc новой задачи 
    	# и переключит режим выполнения назад
    	mret

_loop:
	wfi
	j _loop

# Macros of context saving in stack of current task
.macro SAVE_CONTEXT
    	addi sp, sp, -128	# Allocate space in the stack to
				# 31 register with aligment.
    
	# Save general-using registers (do not save x0 and sp)
    	sw x1,  0(sp)	# ra
    	sw x3,  4(sp)	# gp
    	sw x4,  8(sp)	# tp
    	sw x5,  12(sp)	# t0
    	sw x6,  16(sp)	# t1
    	sw x7,  20(sp)	# t2
    	sw x8,  24(sp)	# s0
    	sw x9,  28(sp)	# s1
    	sw x10, 32(sp)	# a0
    	sw x11, 36(sp)	# a1
    	sw x12, 40(sp)	# a2
    	sw x13, 44(sp)	# a3
    	sw x14, 48(sp)	# a4
    	sw x15, 52(sp)	# a5
    	sw x16, 56(sp)	# a6
    	sw x17, 60(sp)	# a7
    	sw x18, 64(sp)	# s2
    	sw x19, 68(sp)	# s3
    	sw x20, 72(sp)	# s4
    	sw x21, 76(sp)	# s5
    	sw x22, 80(sp)	# s6
    	sw x23, 84(sp)	# s7
    	sw x24, 88(sp)	# s8
    	sw x25, 92(sp)	# s9
    	sw x26, 96(sp)	# s10
    	sw x27, 100(sp)	# s11
    	sw x28, 104(sp)	# t3
    	sw x29, 108(sp)	# t4
    	sw x30, 112(sp)	# t5
    	sw x31, 116(sp)	# t6

	# Read and save mepc register (where return after interrupt)
    	csrr t0, mepc
    	sw   t0, 120(sp)
.endm

# Macros of recovering context from stack of task
.macro RESTORE_CONTEXT
	# Recover mepc and put it to CSR
    	lw   t0, 120(sp)
    	csrw mepc, t0

	# Recover general-using registers
    	lw x1,  0(sp)
    	lw x3,  4(sp)
    	lw x4,  8(sp)
    	lw x5,  12(sp)
	lw x6,  16(sp)
    	lw x7,  20(sp)
    	lw x8,  24(sp)
    	lw x9,  28(sp)
    	lw x10, 32(sp)
    	lw x11, 36(sp)
    	lw x12, 40(sp)
    	lw x13, 44(sp)
    	lw x14, 48(sp)
    	lw x15, 52(sp)
    	lw x16, 56(sp)
    	lw x17, 60(sp)
    	lw x18, 64(sp)
    	lw x19, 68(sp)
    	lw x20, 72(sp)
    	lw x21, 76(sp)
    	lw x22, 80(sp)
    	lw x23, 84(sp)
    	lw x24, 88(sp)
    	lw x25, 92(sp)
    	lw x26, 96(sp)
    	lw x27, 100(sp)
    	lw x28, 104(sp)
    	lw x29, 108(sp)
    	lw x30, 112(sp)
    	lw x31, 116(sp)

    	addi sp, sp, 128	# Освобождаем место в стеке
.endm
