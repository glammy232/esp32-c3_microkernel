.section .init
.global _start
.type _start, @function

_start:
    .option push
    .option norelax
    la sp, _stack_top
    la gp, __global_pointer$
    .option pop

    mv s0, zero

	li t0, 0x600080A4
	li t1, 0x50D83AA1
	sw t1, 0(t0)

	li t0, 0x60008098      # RTC_CNTL_WDTCONFIG0_REG
	lw t1, 0(t0)
	li t2, 0x80000000      # бит 31 = RTC_CNTL_WDT_EN
	not t2, t2
	and t1, t1, t2
	sw t1, 0(t0)

	li t0, 0x600080A4
	sw zero, 0(t0)

    la t0, __bss_start
    la t1, __bss_end
	beq t0, t1, _bss_clear_done

_bss_clear_loop:
    sb zero, 0(t0)
    addi t0, t0, 4
    bltu t0, t1, _bss_clear_loop

_bss_clear_done:
    call mmain

_loop:
    wfi
    j _loop

