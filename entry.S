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

    # turning off TIMG0 WDT
    li t0, 0x6001F064          # TIMG0_WDTWPROTECT_REG
    li t1, 0x50D83AA1
    sw t1, 0(t0)

    li t0, 0x6001F048          # TIMG0_WDTCONFIG0_REG
    lw t1, 0(t0)
    li t2, 0x80004000          # bit 31 (EN), bit 14 (FLASHBOOT_MOD_EN)
    not t2, t2
    and t1, t1, t2
    sw t1, 0(t0)

    li t0, 0x6001F064
    sw zero, 0(t0)

    # turning off RTC_CNTL WDT
    li t0, 0x600080A4          # RTC_CNTL_WDTWPROTECT_REG
    li t1, 0x50D83AA1
    sw t1, 0(t0)

    li t0, 0x60008098          # RTC_CNTL_WDTCONFIG0_REG
    lw t1, 0(t0)
    li t2, 0x80000000          # bit 31 = RTC_CNTL_WDT_EN
    not t2, t2
    and t1, t1, t2
    sw t1, 0(t0)

    li t0, 0x600080A4
    sw zero, 0(t0)

    # turning off Super Watchdog (SWD)
    li t0, 0x600080B8          # RTC_CNTL_SWD_WPROTECT_REG
    li t1, 0x8F1D312A
    sw t1, 0(t0)

    li t0, 0x600080B4          # RTC_CNTL_SWD_CONF_REG
    lw t1, 0(t0)
    li t2, 0x40000000          # bit 30 = SWD_DISABLE
    or t1, t1, t2
    li t2, 0x80000000          # bit 31 = SWD_AUTO_FEED_EN
    not t2, t2
    and t1, t1, t2
    sw t1, 0(t0)

    li t0, 0x600080B8
    sw zero, 0(t0)

    #la t0, __bss_start
    #la t1, __bss_end

	call mmain

#_bss_clear_loop:
#    sw zero, 0(t0)
#    addi t0, t0, 4
#    bltu t0, t1, _bss_clear_loop

#_bss_clear_done:
#    call mmain

#_loop:
#    wfi
#    j _loop
