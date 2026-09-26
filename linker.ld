ENTRY(_start)

MEMORY
{
	iram_seg (RX) : ORIGIN = 0x40380000, LENGTH = 384K
	dram_seg (RW) : ORIGIN = 0x3FC80000, LENGTH = 384K
}

SECTIONS
{
	.text :
	{
		. = ALIGN(4);
		KEEP(*(.init))
		*(.text .text.*)
		. = ALIGN(4);
	} > iram_seg

	.rodata :
	{
		. = ALIGN(4);
		*(.rodata .rodata.*)
		. = ALIGN(4);
	} > dram_seg

	.data :
	{
		. = ALIGN(4);
		*(.data .data.*)
		. = ALIGN(4);
	} > dram_seg

	.bss :
	{
		. = ALIGN(4);
		__bss_start = .;
		*(.bss .bss.*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end = .;
	} > dram_seg

	_stack_top = ALIGN((ORIGIN(dram_seg) + LENGTH(dram_seg)) - 16, 16);

	_end = .;
}
