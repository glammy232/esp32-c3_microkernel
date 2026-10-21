
kernel.elf:     file format elf32-littleriscv


Disassembly of section .text:

40380000 <_start>:
_start():
/home/glammy/projects/esp32-c3_microkernel/entry.S:8
.type _start, @function

_start:
    .option push
    .option norelax
    la sp, _stack_top
40380000:	ff934117          	auipc	sp,0xff934
40380004:	ff010113          	add	sp,sp,-16 # 3fcb3ff0 <_stack_top>
/home/glammy/projects/esp32-c3_microkernel/entry.S:9
    la gp, __global_pointer$
40380008:	ff900197          	auipc	gp,0xff900
4038000c:	7f818193          	add	gp,gp,2040 # 3fc80800 <proc0_kstack>
/home/glammy/projects/esp32-c3_microkernel/entry.S:12
    .option pop

    mv s0, zero
40380010:	00000413          	li	s0,0
/home/glammy/projects/esp32-c3_microkernel/entry.S:19
    # ============================================================
    # ОТКЛЮЧЕНИЕ ВСЕХ WATCHDOG КАК МОЖНО РАНЬШЕ
    # ============================================================

    # ---- 1. TIMG0 WDT ----
    li t0, 0x6001F064          # TIMG0_WDTWPROTECT_REG
40380014:	6001f2b7          	lui	t0,0x6001f
40380018:	06428293          	add	t0,t0,100 # 6001f064 <trap_handler+0x1fc9ea84>
/home/glammy/projects/esp32-c3_microkernel/entry.S:20
    li t1, 0x50D83AA1
4038001c:	50d84337          	lui	t1,0x50d84
40380020:	aa130313          	add	t1,t1,-1375 # 50d83aa1 <trap_handler+0x10a034c1>
/home/glammy/projects/esp32-c3_microkernel/entry.S:21
    sw t1, 0(t0)
40380024:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:23

    li t0, 0x6001F048          # TIMG0_WDTCONFIG0_REG
40380028:	6001f2b7          	lui	t0,0x6001f
4038002c:	04828293          	add	t0,t0,72 # 6001f048 <trap_handler+0x1fc9ea68>
/home/glammy/projects/esp32-c3_microkernel/entry.S:24
    lw t1, 0(t0)
40380030:	0002a303          	lw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:25
    li t2, 0x80004000          # бит 31 (EN) | бит 14 (FLASHBOOT_MOD_EN)
40380034:	800043b7          	lui	t2,0x80004
/home/glammy/projects/esp32-c3_microkernel/entry.S:26
    not t2, t2
40380038:	fff3c393          	not	t2,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:27
    and t1, t1, t2
4038003c:	00737333          	and	t1,t1,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:28
    sw t1, 0(t0)
40380040:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:30

    li t0, 0x6001F064
40380044:	6001f2b7          	lui	t0,0x6001f
40380048:	06428293          	add	t0,t0,100 # 6001f064 <trap_handler+0x1fc9ea84>
/home/glammy/projects/esp32-c3_microkernel/entry.S:31
    sw zero, 0(t0)
4038004c:	0002a023          	sw	zero,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:34

    # ---- 2. RTC_CNTL WDT ----
    li t0, 0x600080A4          # RTC_CNTL_WDTWPROTECT_REG
40380050:	600082b7          	lui	t0,0x60008
40380054:	0a428293          	add	t0,t0,164 # 600080a4 <trap_handler+0x1fc87ac4>
/home/glammy/projects/esp32-c3_microkernel/entry.S:35
    li t1, 0x50D83AA1
40380058:	50d84337          	lui	t1,0x50d84
4038005c:	aa130313          	add	t1,t1,-1375 # 50d83aa1 <trap_handler+0x10a034c1>
/home/glammy/projects/esp32-c3_microkernel/entry.S:36
    sw t1, 0(t0)
40380060:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:38

    li t0, 0x60008098          # RTC_CNTL_WDTCONFIG0_REG
40380064:	600082b7          	lui	t0,0x60008
40380068:	09828293          	add	t0,t0,152 # 60008098 <trap_handler+0x1fc87ab8>
/home/glammy/projects/esp32-c3_microkernel/entry.S:39
    lw t1, 0(t0)
4038006c:	0002a303          	lw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:40
    li t2, 0x80000000          # бит 31 = RTC_CNTL_WDT_EN
40380070:	800003b7          	lui	t2,0x80000
/home/glammy/projects/esp32-c3_microkernel/entry.S:41
    not t2, t2
40380074:	fff3c393          	not	t2,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:42
    and t1, t1, t2
40380078:	00737333          	and	t1,t1,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:43
    sw t1, 0(t0)
4038007c:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:45

    li t0, 0x600080A4
40380080:	600082b7          	lui	t0,0x60008
40380084:	0a428293          	add	t0,t0,164 # 600080a4 <trap_handler+0x1fc87ac4>
/home/glammy/projects/esp32-c3_microkernel/entry.S:46
    sw zero, 0(t0)
40380088:	0002a023          	sw	zero,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:50

    # ---- 3. Super Watchdog (SWD) ----
    # ВНИМАНИЕ: у SWD ДРУГОЙ ключ разблокировки — 0x8F1D312A
    li t0, 0x600080B8          # RTC_CNTL_SWD_WPROTECT_REG
4038008c:	600082b7          	lui	t0,0x60008
40380090:	0b828293          	add	t0,t0,184 # 600080b8 <trap_handler+0x1fc87ad8>
/home/glammy/projects/esp32-c3_microkernel/entry.S:51
    li t1, 0x8F1D312A
40380094:	8f1d3337          	lui	t1,0x8f1d3
40380098:	12a30313          	add	t1,t1,298 # 8f1d312a <trap_handler+0x4ee52b4a>
/home/glammy/projects/esp32-c3_microkernel/entry.S:52
    sw t1, 0(t0)
4038009c:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:54

    li t0, 0x600080B4          # RTC_CNTL_SWD_CONF_REG
403800a0:	600082b7          	lui	t0,0x60008
403800a4:	0b428293          	add	t0,t0,180 # 600080b4 <trap_handler+0x1fc87ad4>
/home/glammy/projects/esp32-c3_microkernel/entry.S:55
    lw t1, 0(t0)
403800a8:	0002a303          	lw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:56
    li t2, 0x40000000          # бит 30 = SWD_DISABLE
403800ac:	400003b7          	lui	t2,0x40000
/home/glammy/projects/esp32-c3_microkernel/entry.S:57
    or t1, t1, t2
403800b0:	00736333          	or	t1,t1,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:58
    li t2, 0x80000000          # бит 31 = SWD_AUTO_FEED_EN — сбросить
403800b4:	800003b7          	lui	t2,0x80000
/home/glammy/projects/esp32-c3_microkernel/entry.S:59
    not t2, t2
403800b8:	fff3c393          	not	t2,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:60
    and t1, t1, t2
403800bc:	00737333          	and	t1,t1,t2
/home/glammy/projects/esp32-c3_microkernel/entry.S:61
    sw t1, 0(t0)
403800c0:	0062a023          	sw	t1,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:63

    li t0, 0x600080B8
403800c4:	600082b7          	lui	t0,0x60008
403800c8:	0b828293          	add	t0,t0,184 # 600080b8 <trap_handler+0x1fc87ad8>
/home/glammy/projects/esp32-c3_microkernel/entry.S:64
    sw zero, 0(t0)
403800cc:	0002a023          	sw	zero,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:70

    # ============================================================
    # ОЧИСТКА BSS
    # ============================================================

    la t0, __bss_start
403800d0:	ff900297          	auipc	t0,0xff900
403800d4:	f3028293          	add	t0,t0,-208 # 3fc80000 <__bss_start>
/home/glammy/projects/esp32-c3_microkernel/entry.S:71
    la t1, __bss_end
403800d8:	ff903317          	auipc	t1,0xff903
403800dc:	11830313          	add	t1,t1,280 # 3fc831f0 <__bss_end>
/home/glammy/projects/esp32-c3_microkernel/entry.S:74
    #beq t0, t1, _bss_clear_done
	#beq t0, t1, _bss_clear_loop
	call mmain
403800e0:	00000097          	auipc	ra,0x0
403800e4:	48e080e7          	jalr	1166(ra) # 4038056e <mmain>

403800e8 <_bss_clear_loop>:
_bss_clear_loop():
/home/glammy/projects/esp32-c3_microkernel/entry.S:77

_bss_clear_loop:
    sw zero, 0(t0)
403800e8:	0002a023          	sw	zero,0(t0)
/home/glammy/projects/esp32-c3_microkernel/entry.S:78
    addi t0, t0, 4
403800ec:	0291                	add	t0,t0,4
/home/glammy/projects/esp32-c3_microkernel/entry.S:79
    bltu t0, t1, _bss_clear_loop
403800ee:	fe62ede3          	bltu	t0,t1,403800e8 <_bss_clear_loop>

403800f2 <_bss_clear_done>:
_bss_clear_done():
/home/glammy/projects/esp32-c3_microkernel/entry.S:82

_bss_clear_done:
    call mmain
403800f2:	00000097          	auipc	ra,0x0
403800f6:	47c080e7          	jalr	1148(ra) # 4038056e <mmain>

403800fa <_loop>:
_loop():
/home/glammy/projects/esp32-c3_microkernel/entry.S:85

_loop:
    wfi
403800fa:	10500073          	wfi
/home/glammy/projects/esp32-c3_microkernel/entry.S:86
    j _loop
403800fe:	bff5                	j	403800fa <_loop>

40380100 <machine_pop_trapframe>:
machine_pop_trapframe():
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:5
# Machine pop trapframe (func place in entry.c)

.global machine_pop_trapframe
machine_pop_trapframe:
	lw t0, 124(a0)
40380100:	07c52283          	lw	t0,124(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:6
	csrw mepc, t0
40380104:	34129073          	csrw	mepc,t0
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:8

	lw t0, 132(a0)
40380108:	08452283          	lw	t0,132(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:9
	csrw mstatus, t0
4038010c:	30029073          	csrw	mstatus,t0
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:11

	lw ra, 0(a0)
40380110:	00052083          	lw	ra,0(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:12
	lw gp, 8(a0)
40380114:	00852183          	lw	gp,8(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:13
	lw tp, 12(a0)
40380118:	00c52203          	lw	tp,12(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:15

    lw t1, 20(a0)
4038011c:	01452303          	lw	t1,20(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:16
    lw t2, 24(a0)
40380120:	01852383          	lw	t2,24(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:18

    lw s0, 28(a0)
40380124:	4d40                	lw	s0,28(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:19
    lw s1, 32(a0)
40380126:	5104                	lw	s1,32(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:21

	lw a1, 40(a0)
40380128:	550c                	lw	a1,40(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:22
	lw a2, 44(a0)
4038012a:	5550                	lw	a2,44(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:23
	lw a3, 48(a0)
4038012c:	5914                	lw	a3,48(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:24
	lw a4, 52(a0)
4038012e:	5958                	lw	a4,52(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:25
	lw a5, 56(a0)
40380130:	5d1c                	lw	a5,56(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:26
	lw a6, 60(a0)
40380132:	03c52803          	lw	a6,60(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:27
	lw a7, 64(a0)
40380136:	04052883          	lw	a7,64(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:29

	lw s2, 68(a0)
4038013a:	04452903          	lw	s2,68(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:30
	lw s3, 72(a0)
4038013e:	04852983          	lw	s3,72(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:31
	lw s4, 76(a0)
40380142:	04c52a03          	lw	s4,76(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:32
	lw s5, 80(a0)
40380146:	05052a83          	lw	s5,80(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:33
	lw s6, 84(a0)
4038014a:	05452b03          	lw	s6,84(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:34
	lw s7, 88(a0)
4038014e:	05852b83          	lw	s7,88(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:35
	lw s8, 92(a0)
40380152:	05c52c03          	lw	s8,92(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:36
	lw s9, 96(a0)
40380156:	06052c83          	lw	s9,96(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:37
	lw s10, 100(a0)
4038015a:	06452d03          	lw	s10,100(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:38
	lw s11, 104(a0)
4038015e:	06852d83          	lw	s11,104(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:40

	lw t3, 108(a0)
40380162:	06c52e03          	lw	t3,108(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:41
	lw t4, 112(a0)
40380166:	07052e83          	lw	t4,112(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:42
	lw t5, 116(a0)
4038016a:	07452f03          	lw	t5,116(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:43
	lw t6, 120(a0)
4038016e:	07852f83          	lw	t6,120(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:45

    lw sp, 4(a0)
40380172:	00452103          	lw	sp,4(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:47

	lw t0, 16(a0)
40380176:	01052283          	lw	t0,16(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:48
	lw a0, 36(a0)
4038017a:	5148                	lw	a0,36(a0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:51

    # jump into the process, interrupts enable thanks to mstatus.mpie
    mret
4038017c:	30200073          	mret

40380180 <trap_vector>:
trap_vector():
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:56

.global trap_vector
.align 4
trap_vector:
	csrw mscratch, t0
40380180:	34029073          	csrw	mscratch,t0
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:58

	la t0, cpu0
40380184:	ff903297          	auipc	t0,0xff903
40380188:	02c28293          	add	t0,t0,44 # 3fc831b0 <cpu0>
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:59
	lw t0, 0(t0)
4038018c:	0002a283          	lw	t0,0(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:61

	sw ra, 0(t0)
40380190:	0012a023          	sw	ra,0(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:62
	sw sp, 4(t0)
40380194:	0022a223          	sw	sp,4(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:63
	sw gp, 8(t0)
40380198:	0032a423          	sw	gp,8(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:64
	sw tp, 12(t0)
4038019c:	0042a623          	sw	tp,12(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:66

	sw t1, 20(t0)
403801a0:	0062aa23          	sw	t1,20(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:67
	sw t2, 24(t0)
403801a4:	0072ac23          	sw	t2,24(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:69

	csrr t1, mscratch
403801a8:	34002373          	csrr	t1,mscratch
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:70
	sw t1, 16(t0)
403801ac:	0062a823          	sw	t1,16(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:72

	sw s0, 28(t0)
403801b0:	0082ae23          	sw	s0,28(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:73
	sw s1, 32(t0)
403801b4:	0292a023          	sw	s1,32(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:75

	sw a0, 36(t0)
403801b8:	02a2a223          	sw	a0,36(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:76
	sw a1, 40(t0)
403801bc:	02b2a423          	sw	a1,40(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:77
	sw a2, 44(t0)
403801c0:	02c2a623          	sw	a2,44(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:78
	sw a3, 48(t0)
403801c4:	02d2a823          	sw	a3,48(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:79
	sw a4, 52(t0)
403801c8:	02e2aa23          	sw	a4,52(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:80
	sw a5, 56(t0)
403801cc:	02f2ac23          	sw	a5,56(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:81
	sw a6, 60(t0)
403801d0:	0302ae23          	sw	a6,60(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:82
	sw a7, 64(t0)
403801d4:	0512a023          	sw	a7,64(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:84

	sw s2, 68(t0)
403801d8:	0522a223          	sw	s2,68(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:85
	sw s3, 72(t0)
403801dc:	0532a423          	sw	s3,72(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:86
	sw s4, 76(t0)
403801e0:	0542a623          	sw	s4,76(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:87
	sw s5, 80(t0)
403801e4:	0552a823          	sw	s5,80(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:88
	sw s6, 84(t0)
403801e8:	0562aa23          	sw	s6,84(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:89
	sw s7, 88(t0)
403801ec:	0572ac23          	sw	s7,88(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:90
	sw s8, 92(t0)
403801f0:	0582ae23          	sw	s8,92(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:91
	sw s9, 96(t0)
403801f4:	0792a023          	sw	s9,96(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:92
	sw s10, 100(t0)
403801f8:	07a2a223          	sw	s10,100(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:93
	sw s11, 104(t0)
403801fc:	07b2a423          	sw	s11,104(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:95

	sw t3, 108(t0)
40380200:	07c2a623          	sw	t3,108(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:96
	sw t4, 112(t0)
40380204:	07d2a823          	sw	t4,112(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:97
	sw t5, 116(t0)
40380208:	07e2aa23          	sw	t5,116(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:98
	sw t6, 120(t0)
4038020c:	07f2ac23          	sw	t6,120(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:100

	csrr t1, mepc
40380210:	34102373          	csrr	t1,mepc
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:101
	sw t1, 124(t0)
40380214:	0662ae23          	sw	t1,124(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:102
	csrr t1, mcause
40380218:	34202373          	csrr	t1,mcause
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:103
	sw t1, 128(t0)
4038021c:	0862a023          	sw	t1,128(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:104
	csrr t1, mstatus
40380220:	30002373          	csrr	t1,mstatus
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:105
	sw t1, 132(t0)
40380224:	0862a223          	sw	t1,132(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:107

	la sp, trap_stack_top
40380228:	ff900117          	auipc	sp,0xff900
4038022c:	5d810113          	add	sp,sp,1496 # 3fc80800 <proc0_kstack>
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:109

	call trap_handler
40380230:	00000097          	auipc	ra,0x0
40380234:	3b0080e7          	jalr	944(ra) # 403805e0 <trap_handler>
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:111

	la t0, cpu0
40380238:	ff903297          	auipc	t0,0xff903
4038023c:	f7828293          	add	t0,t0,-136 # 3fc831b0 <cpu0>
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:112
	lw a0, 0(t0)
40380240:	0002a503          	lw	a0,0(t0)
/home/glammy/projects/esp32-c3_microkernel/trapvec.S:113
	j machine_pop_trapframe
40380244:	bd75                	j	40380100 <machine_pop_trapframe>
40380246:	0001                	nop
40380248:	00000013          	nop
4038024c:	00000013          	nop

40380250 <init_uart0>:
init_uart0():
/home/glammy/projects/esp32-c3_microkernel/entry.c:56
#define UART0_CLKDIV_REG ((volatile uint32_t *)0x60000014)
#define UART0_CONF0_REG ((volatile uint32_t *)0x60000020)
#define UART_CLKDIV_115200_40M (0x15B3)

void init_uart0(void)
{
40380250:	1101                	add	sp,sp,-32
40380252:	ce22                	sw	s0,28(sp)
40380254:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:57
	*UART0_CLKDIV_REG = UART_CLKDIV_115200_40M;
40380256:	600007b7          	lui	a5,0x60000
4038025a:	07d1                	add	a5,a5,20 # 60000014 <trap_handler+0x1fc7fa34>
4038025c:	6705                	lui	a4,0x1
4038025e:	5b370713          	add	a4,a4,1459 # 15b3 <__bss_start-0x3fc7ea4d>
40380262:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:59

	uint32_t conf0 = 0;
40380264:	fe042623          	sw	zero,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:60
	conf0 |= (3 << 2);
40380268:	fec42783          	lw	a5,-20(s0)
4038026c:	00c7e793          	or	a5,a5,12
40380270:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:61
	conf0 |= (1 << 4);
40380274:	fec42783          	lw	a5,-20(s0)
40380278:	0107e793          	or	a5,a5,16
4038027c:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:62
	*UART0_CONF0_REG = conf0;
40380280:	600007b7          	lui	a5,0x60000
40380284:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
40380288:	fec42703          	lw	a4,-20(s0)
4038028c:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:64

	*UART0_CONF0_REG |= (1 << 18);
4038028e:	600007b7          	lui	a5,0x60000
40380292:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
40380296:	4394                	lw	a3,0(a5)
40380298:	600007b7          	lui	a5,0x60000
4038029c:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
403802a0:	00040737          	lui	a4,0x40
403802a4:	8f55                	or	a4,a4,a3
403802a6:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:65
	*UART0_CONF0_REG |= (1 << 19);
403802a8:	600007b7          	lui	a5,0x60000
403802ac:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
403802b0:	4394                	lw	a3,0(a5)
403802b2:	600007b7          	lui	a5,0x60000
403802b6:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
403802ba:	00080737          	lui	a4,0x80
403802be:	8f55                	or	a4,a4,a3
403802c0:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:66
	*UART0_CONF0_REG &= ~((1 << 18) | (1 << 19));
403802c2:	600007b7          	lui	a5,0x60000
403802c6:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
403802ca:	4394                	lw	a3,0(a5)
403802cc:	600007b7          	lui	a5,0x60000
403802d0:	02078793          	add	a5,a5,32 # 60000020 <trap_handler+0x1fc7fa40>
403802d4:	fff40737          	lui	a4,0xfff40
403802d8:	177d                	add	a4,a4,-1 # fff3ffff <trap_handler+0xbfbbfa1f>
403802da:	8f75                	and	a4,a4,a3
403802dc:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:67
}
403802de:	0001                	nop
403802e0:	4472                	lw	s0,28(sp)
403802e2:	6105                	add	sp,sp,32
403802e4:	8082                	ret

403802e6 <delay_ms>:
delay_ms():
/home/glammy/projects/esp32-c3_microkernel/entry.c:70

void delay_ms(uint32_t ms)
{
403802e6:	7179                	add	sp,sp,-48
403802e8:	d622                	sw	s0,44(sp)
403802ea:	1800                	add	s0,sp,48
403802ec:	fca42e23          	sw	a0,-36(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:71
	volatile uint32_t count = ms * 150000;
403802f0:	fdc42703          	lw	a4,-36(s0)
403802f4:	000257b7          	lui	a5,0x25
403802f8:	9f078793          	add	a5,a5,-1552 # 249f0 <__bss_start-0x3fc5b610>
403802fc:	02f707b3          	mul	a5,a4,a5
40380300:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:73

	while (count--) {
40380304:	a011                	j	40380308 <delay_ms+0x22>
/home/glammy/projects/esp32-c3_microkernel/entry.c:74
		asm volatile("nop" : : : "memory");
40380306:	0001                	nop
/home/glammy/projects/esp32-c3_microkernel/entry.c:73
	while (count--) {
40380308:	fec42783          	lw	a5,-20(s0)
4038030c:	fff78713          	add	a4,a5,-1
40380310:	fee42623          	sw	a4,-20(s0)
40380314:	fbed                	bnez	a5,40380306 <delay_ms+0x20>
/home/glammy/projects/esp32-c3_microkernel/entry.c:76
	}
}
40380316:	0001                	nop
40380318:	0001                	nop
4038031a:	5432                	lw	s0,44(sp)
4038031c:	6145                	add	sp,sp,48
4038031e:	8082                	ret

40380320 <uart_putchar>:
uart_putchar():
/home/glammy/projects/esp32-c3_microkernel/entry.c:79

void uart_putchar(char c)
{
40380320:	1101                	add	sp,sp,-32
40380322:	ce22                	sw	s0,28(sp)
40380324:	1000                	add	s0,sp,32
40380326:	87aa                	mv	a5,a0
40380328:	fef407a3          	sb	a5,-17(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:80
	while (((*UART0_STATUS_REG) & UART_TXFIFO_CNT_M) >= 126)
4038032c:	0001                	nop
/home/glammy/projects/esp32-c3_microkernel/entry.c:80 (discriminator 1)
4038032e:	600007b7          	lui	a5,0x60000
40380332:	07f1                	add	a5,a5,28 # 6000001c <trap_handler+0x1fc7fa3c>
40380334:	439c                	lw	a5,0(a5)
40380336:	3ff7f713          	and	a4,a5,1023
4038033a:	07d00793          	li	a5,125
4038033e:	fee7e8e3          	bltu	a5,a4,4038032e <uart_putchar+0xe>
/home/glammy/projects/esp32-c3_microkernel/entry.c:83
		;

	*UART0_FIFO_REG = (uint32_t)c;
40380342:	600007b7          	lui	a5,0x60000
40380346:	fef44703          	lbu	a4,-17(s0)
4038034a:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:84
}
4038034c:	0001                	nop
4038034e:	4472                	lw	s0,28(sp)
40380350:	6105                	add	sp,sp,32
40380352:	8082                	ret

40380354 <init_hardware>:
init_hardware():
/home/glammy/projects/esp32-c3_microkernel/entry.c:97
	uart_putchar('\n');
}
#endif

void init_hardware(void)
{
40380354:	1101                	add	sp,sp,-32
40380356:	ce22                	sw	s0,28(sp)
40380358:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:117
	*RTC_CNTL_SWD_CONF_REG |= (1u << 30);	 // SWD_DISABLE = 1
	*RTC_CNTL_SWD_WPROTECT_REG = 0;
#endif

#if 1
	uint32_t reg_val = *IO_MUX_GPIO8_REG;
4038035a:	600097b7          	lui	a5,0x60009
4038035e:	02478793          	add	a5,a5,36 # 60009024 <trap_handler+0x1fc88a44>
40380362:	439c                	lw	a5,0(a5)
40380364:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:118
	reg_val &= ~((7 << 12) | (1 << 7) | (1 << 8));
40380368:	fec42703          	lw	a4,-20(s0)
4038036c:	77e5                	lui	a5,0xffff9
4038036e:	e7f78793          	add	a5,a5,-385 # ffff8e7f <trap_handler+0xbfc7889f>
40380372:	8ff9                	and	a5,a5,a4
40380374:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:119
	reg_val |= (1 << 12);
40380378:	fec42703          	lw	a4,-20(s0)
4038037c:	6785                	lui	a5,0x1
4038037e:	8fd9                	or	a5,a5,a4
40380380:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:120
	*IO_MUX_GPIO8_REG = reg_val;
40380384:	600097b7          	lui	a5,0x60009
40380388:	02478793          	add	a5,a5,36 # 60009024 <trap_handler+0x1fc88a44>
4038038c:	fec42703          	lw	a4,-20(s0)
40380390:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:121
	*GPIO_ENABLE_REG |= (1 << LED_PIN);
40380392:	600047b7          	lui	a5,0x60004
40380396:	02078793          	add	a5,a5,32 # 60004020 <trap_handler+0x1fc83a40>
4038039a:	4398                	lw	a4,0(a5)
4038039c:	600047b7          	lui	a5,0x60004
403803a0:	02078793          	add	a5,a5,32 # 60004020 <trap_handler+0x1fc83a40>
403803a4:	10076713          	or	a4,a4,256
403803a8:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:123
#endif
}
403803aa:	0001                	nop
403803ac:	4472                	lw	s0,28(sp)
403803ae:	6105                	add	sp,sp,32
403803b0:	8082                	ret

403803b2 <init_timer>:
init_timer():
/home/glammy/projects/esp32-c3_microkernel/entry.c:126

void init_timer(void)
{
403803b2:	1101                	add	sp,sp,-32
403803b4:	ce22                	sw	s0,28(sp)
403803b6:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:127
	uint32_t delay = 160000;
403803b8:	000277b7          	lui	a5,0x27
403803bc:	10078793          	add	a5,a5,256 # 27100 <__bss_start-0x3fc58f00>
403803c0:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:129

	*INTERRUPT_CORE0_SYSTIMER_TARGET0_INT_MAP_REG = 7;
403803c4:	600c27b7          	lui	a5,0x600c2
403803c8:	09c78793          	add	a5,a5,156 # 600c209c <trap_handler+0x1fd41abc>
403803cc:	471d                	li	a4,7
403803ce:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:132

	/* connect Systimer to CPU Interrupt 7 */
	*INTERRUPT_CORE0_CPU_INT_ENABLE_REG |= (1 << 7);
403803d0:	600c27b7          	lui	a5,0x600c2
403803d4:	4398                	lw	a4,0(a5)
403803d6:	600c27b7          	lui	a5,0x600c2
403803da:	08076713          	or	a4,a4,128
403803de:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:134

	*SYSTIMER_INT_CLR_REG = (1 << 0);
403803e0:	600237b7          	lui	a5,0x60023
403803e4:	07d1                	add	a5,a5,20 # 60023014 <trap_handler+0x1fca2a34>
403803e6:	4705                	li	a4,1
403803e8:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:137

	/* setting system timer comparator */
	*SYSTIMER_TARGET0_LO_REG = delay;
403803ea:	600237b7          	lui	a5,0x60023
403803ee:	03478793          	add	a5,a5,52 # 60023034 <trap_handler+0x1fca2a54>
403803f2:	fec42703          	lw	a4,-20(s0)
403803f6:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:138
	*SYSTIMER_TARGET0_HI_REG = 0;
403803f8:	600237b7          	lui	a5,0x60023
403803fc:	03078793          	add	a5,a5,48 # 60023030 <trap_handler+0x1fca2a50>
40380400:	0007a023          	sw	zero,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:141

	/* bit 30 = ... mode; bit 29 = turn on comparator */
	*SYSTIMER_CONF_REG |= (1 << 30) | (1 << 29);
40380404:	600237b7          	lui	a5,0x60023
40380408:	4394                	lw	a3,0(a5)
4038040a:	600237b7          	lui	a5,0x60023
4038040e:	60000737          	lui	a4,0x60000
40380412:	8f55                	or	a4,a4,a3
40380414:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:144

	/* accept comparator settings */
	*SYSTIMER_COMP0_LOAD_REG = 1;
40380416:	600237b7          	lui	a5,0x60023
4038041a:	03878793          	add	a5,a5,56 # 60023038 <trap_handler+0x1fca2a58>
4038041e:	4705                	li	a4,1
40380420:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:146

	*SYSTIMER_INT_CLR_REG = (1 << 0);
40380422:	600237b7          	lui	a5,0x60023
40380426:	07d1                	add	a5,a5,20 # 60023014 <trap_handler+0x1fca2a34>
40380428:	4705                	li	a4,1
4038042a:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:148

	uint32_t mie_flags = (1 << 7) | (1 << 11) | (1 << 3);
4038042c:	6785                	lui	a5,0x1
4038042e:	88878793          	add	a5,a5,-1912 # 888 <__bss_start-0x3fc7f778>
40380432:	fef42423          	sw	a5,-24(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:149
	asm volatile("csrs mie, %0" : : "r"(mie_flags));
40380436:	fe842783          	lw	a5,-24(s0)
4038043a:	3047a073          	csrs	mie,a5
/home/glammy/projects/esp32-c3_microkernel/entry.c:152

	// asm volatile("csrs mie, %0" : : "r"(1 << 7));
}
4038043e:	0001                	nop
40380440:	4472                	lw	s0,28(sp)
40380442:	6105                	add	sp,sp,32
40380444:	8082                	ret

40380446 <blink_proc>:
blink_proc():
/home/glammy/projects/esp32-c3_microkernel/entry.c:158

extern void machine_pop_trapframe(struct trapframe *tf);
extern void trap_vector(void);

void blink_proc(void)
{
40380446:	1141                	add	sp,sp,-16
40380448:	c606                	sw	ra,12(sp)
4038044a:	c422                	sw	s0,8(sp)
4038044c:	0800                	add	s0,sp,16
/home/glammy/projects/esp32-c3_microkernel/entry.c:160 (discriminator 1)
	while (1) {
		*GPIO_OUT_W1TC_REG = (1 << LED_PIN);
4038044e:	600047b7          	lui	a5,0x60004
40380452:	07b1                	add	a5,a5,12 # 6000400c <trap_handler+0x1fc83a2c>
40380454:	10000713          	li	a4,256
40380458:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:161 (discriminator 1)
		uart_putchar('O');
4038045a:	04f00513          	li	a0,79
4038045e:	00000097          	auipc	ra,0x0
40380462:	ec2080e7          	jalr	-318(ra) # 40380320 <uart_putchar>
/home/glammy/projects/esp32-c3_microkernel/entry.c:162 (discriminator 1)
		uart_putchar('N');
40380466:	04e00513          	li	a0,78
4038046a:	00000097          	auipc	ra,0x0
4038046e:	eb6080e7          	jalr	-330(ra) # 40380320 <uart_putchar>
/home/glammy/projects/esp32-c3_microkernel/entry.c:163 (discriminator 1)
		uart_putchar('\n');
40380472:	4529                	li	a0,10
40380474:	00000097          	auipc	ra,0x0
40380478:	eac080e7          	jalr	-340(ra) # 40380320 <uart_putchar>
/home/glammy/projects/esp32-c3_microkernel/entry.c:164 (discriminator 1)
		delay_ms(500);
4038047c:	1f400513          	li	a0,500
40380480:	00000097          	auipc	ra,0x0
40380484:	e66080e7          	jalr	-410(ra) # 403802e6 <delay_ms>
/home/glammy/projects/esp32-c3_microkernel/entry.c:166 (discriminator 1)

		*GPIO_OUT_W1TS_REG = (1 << LED_PIN);
40380488:	600047b7          	lui	a5,0x60004
4038048c:	07a1                	add	a5,a5,8 # 60004008 <trap_handler+0x1fc83a28>
4038048e:	10000713          	li	a4,256
40380492:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:167 (discriminator 1)
		uart_putchar('O');
40380494:	04f00513          	li	a0,79
40380498:	00000097          	auipc	ra,0x0
4038049c:	e88080e7          	jalr	-376(ra) # 40380320 <uart_putchar>
/home/glammy/projects/esp32-c3_microkernel/entry.c:168 (discriminator 1)
		uart_putchar('F');
403804a0:	04600513          	li	a0,70
403804a4:	00000097          	auipc	ra,0x0
403804a8:	e7c080e7          	jalr	-388(ra) # 40380320 <uart_putchar>
/home/glammy/projects/esp32-c3_microkernel/entry.c:169 (discriminator 1)
		delay_ms(500);
403804ac:	1f400513          	li	a0,500
403804b0:	00000097          	auipc	ra,0x0
403804b4:	e36080e7          	jalr	-458(ra) # 403802e6 <delay_ms>
/home/glammy/projects/esp32-c3_microkernel/entry.c:160 (discriminator 1)
		*GPIO_OUT_W1TC_REG = (1 << LED_PIN);
403804b8:	bf59                	j	4038044e <blink_proc+0x8>

403804ba <init_trap_handling>:
init_trap_handling():
/home/glammy/projects/esp32-c3_microkernel/entry.c:174
	}
}

void init_trap_handling(void)
{
403804ba:	1101                	add	sp,sp,-32
403804bc:	ce22                	sw	s0,28(sp)
403804be:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:180
	/**
	 * Записываем адрес trap_vector в системный регистр mtvec.
	 * Последние 2 бита регистра mtvec отвечают за режим
	 * (00 = Direct, все прерывания прыгают в одну точку)
	 */
	uint32_t vector_address = (uint32_t)trap_vector & ~0x3;
403804c0:	403807b7          	lui	a5,0x40380
403804c4:	18078793          	add	a5,a5,384 # 40380180 <trap_vector>
403804c8:	9bf1                	and	a5,a5,-4
403804ca:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:182

	asm volatile("csrw mtvec, %0" : : "r"(vector_address));
403804ce:	fec42783          	lw	a5,-20(s0)
403804d2:	30579073          	csrw	mtvec,a5
/home/glammy/projects/esp32-c3_microkernel/entry.c:183
}
403804d6:	0001                	nop
403804d8:	4472                	lw	s0,28(sp)
403804da:	6105                	add	sp,sp,32
403804dc:	8082                	ret

403804de <init_first_process>:
init_first_process():
/home/glammy/projects/esp32-c3_microkernel/entry.c:186

void init_first_process(void)
{
403804de:	1101                	add	sp,sp,-32
403804e0:	ce22                	sw	s0,28(sp)
403804e2:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:187
	struct proc *p = &proc_table[0];
403804e4:	3fc837b7          	lui	a5,0x3fc83
403804e8:	80078793          	add	a5,a5,-2048 # 3fc82800 <proc_table>
403804ec:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:189

	p->pid = 1;
403804f0:	fec42783          	lw	a5,-20(s0)
403804f4:	4705                	li	a4,1
403804f6:	08e7a423          	sw	a4,136(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:190
	p->state = READY;
403804fa:	fec42783          	lw	a5,-20(s0)
403804fe:	0807a623          	sw	zero,140(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:192

	uint32_t kstack_top = (uint32_t)proc0_kstack + STACK_SIZE;
40380502:	3fc817b7          	lui	a5,0x3fc81
40380506:	80078713          	add	a4,a5,-2048 # 3fc80800 <proc0_kstack>
4038050a:	6789                	lui	a5,0x2
4038050c:	97ba                	add	a5,a5,a4
4038050e:	fef42423          	sw	a5,-24(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:193
	p->kstack = kstack_top;
40380512:	fec42783          	lw	a5,-20(s0)
40380516:	fe842703          	lw	a4,-24(s0)
4038051a:	0ae7a023          	sw	a4,160(a5) # 20a0 <__bss_start-0x3fc7df60>
/home/glammy/projects/esp32-c3_microkernel/entry.c:196

	/* where we return after mk initialization */
	p->trapframe.mepc = (uint32_t)blink_proc;
4038051e:	403807b7          	lui	a5,0x40380
40380522:	44678713          	add	a4,a5,1094 # 40380446 <blink_proc>
40380526:	fec42783          	lw	a5,-20(s0)
4038052a:	dff8                	sw	a4,124(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:201

	/* mstatus initialization */
	/* mpie = 1 (get access to interrupts after mret */
	/* mpp = 11 (machine-mode) */
	p->trapframe.mstatus = (3 << 11) | (1 << 7) | (1 << 3);
4038052c:	fec42783          	lw	a5,-20(s0)
40380530:	6709                	lui	a4,0x2
40380532:	88870713          	add	a4,a4,-1912 # 1888 <__bss_start-0x3fc7e778>
40380536:	08e7a223          	sw	a4,132(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:205

	/* setting context for scheduler */
	/* when the scheduler do swtch(), it jumps to context.ra */
	p->context.ra = (uint32_t)machine_pop_trapframe;
4038053a:	403807b7          	lui	a5,0x40380
4038053e:	10078713          	add	a4,a5,256 # 40380100 <machine_pop_trapframe>
40380542:	fec42783          	lw	a5,-20(s0)
40380546:	0ae7a823          	sw	a4,176(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:208

	/* processor will read data from trapframe firstly */
	p->context.sp = (uint32_t)&p->trapframe;
4038054a:	fec42783          	lw	a5,-20(s0)
4038054e:	873e                	mv	a4,a5
40380550:	fec42783          	lw	a5,-20(s0)
40380554:	0ae7aa23          	sw	a4,180(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:210

	cpu0.proc = p;
40380558:	3fc837b7          	lui	a5,0x3fc83
4038055c:	1b078793          	add	a5,a5,432 # 3fc831b0 <cpu0>
40380560:	fec42703          	lw	a4,-20(s0)
40380564:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:211
}
40380566:	0001                	nop
40380568:	4472                	lw	s0,28(sp)
4038056a:	6105                	add	sp,sp,32
4038056c:	8082                	ret

4038056e <mmain>:
mmain():
/home/glammy/projects/esp32-c3_microkernel/entry.c:214

int mmain(void)
{
4038056e:	1101                	add	sp,sp,-32
40380570:	ce06                	sw	ra,28(sp)
40380572:	cc22                	sw	s0,24(sp)
40380574:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/entry.c:215
	for (uint32_t *dest = (uint32_t *)__bss_end;
40380576:	3fc837b7          	lui	a5,0x3fc83
4038057a:	1f078793          	add	a5,a5,496 # 3fc831f0 <__bss_end>
4038057e:	fef42623          	sw	a5,-20(s0)
40380582:	a809                	j	40380594 <mmain+0x26>
/home/glammy/projects/esp32-c3_microkernel/entry.c:217
	     dest < (uint32_t *)__bss_start;) {
		*dest++ = 0;
40380584:	fec42783          	lw	a5,-20(s0)
40380588:	00478713          	add	a4,a5,4
4038058c:	fee42623          	sw	a4,-20(s0)
40380590:	0007a023          	sw	zero,0(a5)
/home/glammy/projects/esp32-c3_microkernel/entry.c:216
	     dest < (uint32_t *)__bss_start;) {
40380594:	fec42703          	lw	a4,-20(s0)
40380598:	3fc807b7          	lui	a5,0x3fc80
4038059c:	00078793          	mv	a5,a5
403805a0:	fef762e3          	bltu	a4,a5,40380584 <mmain+0x16>
/home/glammy/projects/esp32-c3_microkernel/entry.c:220
	}

	init_hardware();
403805a4:	00000097          	auipc	ra,0x0
403805a8:	db0080e7          	jalr	-592(ra) # 40380354 <init_hardware>
/home/glammy/projects/esp32-c3_microkernel/entry.c:222

	init_uart0();
403805ac:	00000097          	auipc	ra,0x0
403805b0:	ca4080e7          	jalr	-860(ra) # 40380250 <init_uart0>
/home/glammy/projects/esp32-c3_microkernel/entry.c:224

	init_trap_handling();
403805b4:	00000097          	auipc	ra,0x0
403805b8:	f06080e7          	jalr	-250(ra) # 403804ba <init_trap_handling>
/home/glammy/projects/esp32-c3_microkernel/entry.c:226

	init_first_process();
403805bc:	00000097          	auipc	ra,0x0
403805c0:	f22080e7          	jalr	-222(ra) # 403804de <init_first_process>
/home/glammy/projects/esp32-c3_microkernel/entry.c:230

	// init_timer();

	struct proc *p = &proc_table[0];
403805c4:	3fc837b7          	lui	a5,0x3fc83
403805c8:	80078793          	add	a5,a5,-2048 # 3fc82800 <proc_table>
403805cc:	fef42423          	sw	a5,-24(s0)
/home/glammy/projects/esp32-c3_microkernel/entry.c:232

	machine_pop_trapframe(&p->trapframe);
403805d0:	fe842783          	lw	a5,-24(s0)
403805d4:	853e                	mv	a0,a5
403805d6:	00000097          	auipc	ra,0x0
403805da:	b2a080e7          	jalr	-1238(ra) # 40380100 <machine_pop_trapframe>
/home/glammy/projects/esp32-c3_microkernel/entry.c:234 (discriminator 1)

	while (1)
403805de:	a001                	j	403805de <mmain+0x70>

403805e0 <trap_handler>:
trap_handler():
/home/glammy/projects/esp32-c3_microkernel/trap.c:15
extern void swtch();

volatile uint32_t ticks_count = 0;

void trap_handler()
{
403805e0:	1101                	add	sp,sp,-32
403805e2:	ce22                	sw	s0,28(sp)
403805e4:	1000                	add	s0,sp,32
/home/glammy/projects/esp32-c3_microkernel/trap.c:16
	struct proc *p = cpu0.proc;
403805e6:	3fc837b7          	lui	a5,0x3fc83
403805ea:	1b078793          	add	a5,a5,432 # 3fc831b0 <cpu0>
403805ee:	439c                	lw	a5,0(a5)
403805f0:	fef42623          	sw	a5,-20(s0)
/home/glammy/projects/esp32-c3_microkernel/trap.c:18

	if (!p) {
403805f4:	fec42783          	lw	a5,-20(s0)
403805f8:	ef81                	bnez	a5,40380610 <trap_handler+0x30>
/home/glammy/projects/esp32-c3_microkernel/trap.c:19
		*SYSTIMER_CONF_REG &= ~(1 << 29);
403805fa:	600237b7          	lui	a5,0x60023
403805fe:	4394                	lw	a3,0(a5)
40380600:	600237b7          	lui	a5,0x60023
40380604:	e0000737          	lui	a4,0xe0000
40380608:	177d                	add	a4,a4,-1 # dfffffff <trap_handler+0x9fc7fa1f>
4038060a:	8f75                	and	a4,a4,a3
4038060c:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/trap.c:21 (discriminator 1)
		// uart_print("[KERNEL] ERROR: cpu0.proc is NULL!");
		while (1)
4038060e:	a001                	j	4038060e <trap_handler+0x2e>
/home/glammy/projects/esp32-c3_microkernel/trap.c:25
			;
	}

	uint32_t mcause = p->trapframe.mcause;
40380610:	fec42783          	lw	a5,-20(s0)
40380614:	0807a783          	lw	a5,128(a5) # 60023080 <trap_handler+0x1fca2aa0>
40380618:	fef42423          	sw	a5,-24(s0)
/home/glammy/projects/esp32-c3_microkernel/trap.c:27

	if (mcause & (1 << 31)) {
4038061c:	fe842783          	lw	a5,-24(s0)
40380620:	0207d263          	bgez	a5,40380644 <trap_handler+0x64>
/home/glammy/projects/esp32-c3_microkernel/trap.c:28
		*SYSTIMER_INT_CLR_REG = (1 << 0);
40380624:	600237b7          	lui	a5,0x60023
40380628:	07d1                	add	a5,a5,20 # 60023014 <trap_handler+0x1fca2a34>
4038062a:	4705                	li	a4,1
4038062c:	c398                	sw	a4,0(a5)
/home/glammy/projects/esp32-c3_microkernel/trap.c:29
		ticks_count++;
4038062e:	3fc837b7          	lui	a5,0x3fc83
40380632:	1ec7a783          	lw	a5,492(a5) # 3fc831ec <ticks_count>
40380636:	00178713          	add	a4,a5,1
4038063a:	3fc837b7          	lui	a5,0x3fc83
4038063e:	1ee7a623          	sw	a4,492(a5) # 3fc831ec <ticks_count>
/home/glammy/projects/esp32-c3_microkernel/trap.c:52
		uart_print(hex);
*/
		while (1)
			;
	}
}
40380642:	a011                	j	40380646 <trap_handler+0x66>
/home/glammy/projects/esp32-c3_microkernel/trap.c:49 (discriminator 2)
		while (1)
40380644:	a001                	j	40380644 <trap_handler+0x64>
/home/glammy/projects/esp32-c3_microkernel/trap.c:52
}
40380646:	4472                	lw	s0,28(sp)
40380648:	6105                	add	sp,sp,32
4038064a:	8082                	ret
