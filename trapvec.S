# Machine pop trapframe (func place in entry.c)

.global machine_pop_trapframe
machine_pop_trapframe:
	lw t0, 124(a0)
	csrw mepc, t0

	lw t0, 132(a0)
	csrw mstatus, t0

	lw ra, 0(a0)
	lw gp, 8(a0)
	lw tp, 12(a0)

    lw t1, 20(a0)
    lw t2, 24(a0)

    lw s0, 28(a0)
    lw s1, 32(a0)

	lw a1, 40(a0)
	lw a2, 44(a0)
	lw a3, 48(a0)
	lw a4, 52(a0)
	lw a5, 56(a0)
	lw a6, 60(a0)
	lw a7, 64(a0)

	lw s2, 68(a0)
	lw s3, 72(a0)
	lw s4, 76(a0)
	lw s5, 80(a0)
	lw s6, 84(a0)
	lw s7, 88(a0)
	lw s8, 92(a0)
	lw s9, 96(a0)
	lw s10, 100(a0)
	lw s11, 104(a0)

	lw t3, 108(a0)
	lw t4, 112(a0)
	lw t5, 116(a0)
	lw t6, 120(a0)

    lw sp, 4(a0)

	lw t0, 16(a0)
	lw a0, 36(a0)

    # jump into the process, interrupts enable thanks to mstatus.mpie
    mret

.global trap_vector
.align 4
trap_vector:
	csrw mscratch, t0

	la t0, cpu0
	lw t0, 0(t0)

	sw ra, 0(t0)
	sw sp, 4(t0)
	sw gp, 8(t0)
	sw tp, 12(t0)

	sw t1, 20(t0)
	sw t2, 24(t0)

	csrr t1, mscratch
	sw t1, 16(t0)

	sw s0, 28(t0)
	sw s1, 32(t0)

	sw a0, 36(t0)
	sw a1, 40(t0)
	sw a2, 44(t0)
	sw a3, 48(t0)
	sw a4, 52(t0)
	sw a5, 56(t0)
	sw a6, 60(t0)
	sw a7, 64(t0)

	sw s2, 68(t0)
	sw s3, 72(t0)
	sw s4, 76(t0)
	sw s5, 80(t0)
	sw s6, 84(t0)
	sw s7, 88(t0)
	sw s8, 92(t0)
	sw s9, 96(t0)
	sw s10, 100(t0)
	sw s11, 104(t0)

	sw t3, 108(t0)
	sw t4, 112(t0)
	sw t5, 116(t0)
	sw t6, 120(t0)

	csrr t1, mepc
	sw t1, 124(t0)
	csrr t1, mcause
	sw t1, 128(t0)
	csrr t1, mstatus
	sw t1, 132(t0)

	la sp, trap_stack_top

	call trap_handler

	la t0, cpu0
	lw a0, 0(t0)
	j machine_pop_trapframe






.section .bss
.align 16
trap_stack_base:
	.space 2048
trap_stack_top:
