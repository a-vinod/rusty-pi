ENTRY(_start)

SECTIONS
{
    . =  0x80000;
    .text :
    {
        KEEP(*(.text._start))
        *(.text._start_kernel)
        *(.text*)
    }

    .rodata : ALIGN(8)
    {
        *(.rodata*)
    }

    .data :
    {
        *(.data*)
    }

    .bss : ALIGN(16)
    {
        __bss_start = .;
        *(.bss*);
        . = ALIGN(16);
        __bss_end = .;
    }
}
