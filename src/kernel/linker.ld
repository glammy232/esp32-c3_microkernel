ENTRY(_start)

MEMORY
{
	iram_seg (RX) : ORIGIN = 0x40380000, LENGTH = 192K
	dram_seg (RW) : ORIGIN = 0x3FC80000, LENGTH = 208K
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
		*(.srodata .srodata.*)
		. = ALIGN(4);
	} > dram_seg

	.data :
	{
		. = ALIGN(4);
		__data_start = .;
		*(.data .data.*)
		*(.sdata .sdata.*)
		. = ALIGN(4);
		__data_end = .;
	} > dram_seg

	. = ALIGN(16);
	__global_pointer$ = . + 0x800;

	.bss :
	{
		. = ALIGN(4);
		__bss_start = .;
		*(.bss .bss.*)
		*(.sbss .sbss.*)
		*(COMMON)
		. = ALIGN(4);
		__bss_end = .;
	} > dram_seg

	_stack_top = ORIGIN(dram_seg) + LENGTH(dram_seg); 

	_stack_top = ALIGN(_stack_top - 16, 16);

	_end = .;
}

