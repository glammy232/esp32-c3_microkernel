# Machine pop trapframe (func place in entry.c)

.global machine_pop_trapframe
machine_pop_trapframe:
	lw t0, 128(sp)
	csrw mepc, t0

	lw t0, 136(sp)
	csrw mstatus, t0

	lw ra, 0(sp)

	lw gp, 8(sp)
	lw tp, 12(sp)
	lw t0, 16(sp)
    lw t1, 20(sp)
    lw t2, 24(sp)
    lw s0, 28(sp)
    lw s1, 32(sp)
    lw a0, 36(sp)
	lw a1, 40(sp)
	lw a2, 44(sp)
	lw a3, 48(sp)
	lw a4, 52(sp)
	lw a5, 56(sp)
	lw a6, 60(sp)
	lw a7, 64(sp)
	lw s2, 68(sp)
	lw s3, 72(sp)
	lw s4, 76(sp)
	lw s5, 80(sp)
	lw s6, 84(sp)
	lw s7, 88(sp)
	lw s8, 92(sp)
	lw s9, 96(sp)
	lw s10, 100(sp)
	lw s11, 104(sp)
	lw t3, 108(sp)
	lw t4, 112(sp)
	lw t5, 116(sp)
	lw t6, 120(sp)
    lw t6, 124(sp)

    lw sp, 4(sp)

    # jump into the process, interrupts enable thanks to mstatus.mpie
    mret
