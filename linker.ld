/* STM32F103C8 Memory Map */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    /* Код та константи у Flash */
    .text :
    {
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        _etext = .;
    } > FLASH

    /* Початкові значення змінних у Flash */
    _sidata = LOADADDR(.data);

    /* Ініціалізовані змінні в RAM */
    .data :
    {
        _sdata = .;
        *(.data*)
        _edata = .;
    } > RAM AT > FLASH

    /* Змінні, що обнуляються в RAM */
    .bss :
    {
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    /* Кінець стека (верх RAM) */
    _estack = ORIGIN(RAM) + LENGTH(RAM);
}