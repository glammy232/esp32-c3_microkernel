.section .trap, "ax"
.align 4
.globl uservec
uservec:
    csrrw a0, mscratch, a0
    
    sw ra, 0(a0)
    sw t0, 4(a0)
    sw t1, 8(a0)
    sw t2, 12(a0)
    sw a1, 16(a0)
    sw a2, 20(a0)
    sw a3, 24(a0)
    sw a4, 28(a0)
    sw a5, 32(a0)
    sw a6, 36(a0)
    sw a7, 40(a0)
    sw t3, 44(a0)
    sw t4, 48(a0)
    sw t5, 52(a0)
    sw t6, 56(a0)

    csrr t0, mscratch
    sw t0, 60(a0)

    lw sp, 64(a0)
    lw t0, 68(a0)

    jalr t0

.globl userret
userret:

    lw ra, 0(a0)
    lw t0, 4(a0)
    lw t1, 8(a0)
    lw t2, 12(a0)
    lw a1, 16(a0)
    lw a2, 20(a0)
    lw a3, 24(a0)
    lw a4, 28(a0)
    lw a5, 32(a0)
    lw a6, 36(a0)
    lw a7, 40(a0)
    lw t3, 44(a0)
    lw t4, 48(a0)
    lw t5, 52(a0)
    lw t6, 56(a0)

    lw a0, 60(a0)

    mret
