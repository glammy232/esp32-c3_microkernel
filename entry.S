.section .init
.global _start
.type _start, @function

_start:
	.option push
	.option norelax

	la sp, _stack_top
	.option pop

	mv s0, zero

	la t0, __bss_start
	la t1, __bss_end
_bss_clear_loop:
	bgeu t0, t1, _bss_clear_done
	sw zero, 0(t0)
	addi t0, t0, 4
	j _bss_clear_loop
_bss_clear_done:
	jal main
_loop:
	wfi
	j _loop
