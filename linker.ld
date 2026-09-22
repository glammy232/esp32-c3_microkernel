ENTRY(_start)

MEMORY
{
  /* Указываем физически одну и ту же SRAM, но разделенную по шинам */
  iram_seg (RX) : ORIGIN = 0x4037C000, LENGTH = 400K
  dram_seg (RW) : ORIGIN = 0x3FC80000, LENGTH = 400K
}

SECTIONS
{
  /* 1. Секция кода (вводная точка и векторы прерываний) */
  .text :
  {
    _stext = .;
    KEEP(*(.entry))       /* Тут будет лежать наша функция _start */
    KEEP(*(.vectors))     /* Тут будет лежать таблица mtvec */
    *(.text .text.*)
    *(.rodata .rodata.*)  /* Константы для простоты тоже положим в IRAM */
    _etext = .;
  } > iram_seg

  /* Выравниваем для PMP по границе 4КБ перед секцией данных */
  . = ALIGN(0x1000);

  /* 2. Секция инициализированных данных */
  .data : AT (_etext)
  {
    _sdata = .;
    *(.data .data.*)
    _edata = .;
  } > dram_seg

  /* 3. Секция неинициализированных данных (обнуляется в boot.S) */
  .bss (NOLOAD) :
  {
    _sbss = .;
    *(.bss .bss.*)
    *(COMMON)
    _ebss = .;
  } > dram_seg

  /* 4. Выделяем место под стек ядра */
  .stack (NOLOAD) :
  {
    . = ALIGN(16);
    . += 0x2000; /* 8 КБ под стек микроядра */
    _stack_top = .;
  } > dram_seg
}

