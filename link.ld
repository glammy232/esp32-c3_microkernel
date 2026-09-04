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
		_text_start = .;
		KEEP(*(.init))
		*(.text .text.*)
		_text_end = .;
	} > iram_seg

	.rodata :
	{
		. = ALIGN(4);
		*(.rodata .rodata.*)
		. = ALIGN(4);
	} > dram_seg

	.data :
	{
		_data_start = .;
		*(.data .data.*)

		. = ALIGN(4);
		__global_pointer$ = . + 0x800;

		_data_end = .;
	} > dram_seg

	.bss :
	{
		. = ALIGN(4);
    		_bss_start = .;
    		*(.bss .bss.*)
    		*(COMMON)
    		. = ALIGN(4);
    		_bss_end = .;
	} > dram_seg

	.stack (NOLOAD) :
	{
		. = ALIGN(16);
		_stack_bottom = .;
		. += 4K;
		_stack_top = .;
	} > dram_seg

	/*_stack_top = ORIGIN(dram_seg) + LENGTH(dram_seg);*/
}
