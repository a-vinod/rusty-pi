ENTRY(_start)

SECTIONS
{
    . = 0x80000;                    /* Assign current address to base addr */
    __start = .;
    __text_start = .;
    .text :
    {
        KEEP(*(.text._start))       /* boot.s isn't referenced anywhere else */
                                    /* so we want to make sure it doesn't get */
                                    /* auto-discarded in the linking process */
        *(.text)                    /* Match all other .text sections */
    }
    . = ALIGN(4096);                /* Jump to next page (4KB) */
    __text_end = .;
    
    /* 4KB rodata */
    __rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096);
    __rodata_end = .;
 
    /* 4KB data */
    __data_start = .;
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096);
    __data_end = .;
 
    /* 4KB BSS */
    __bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096);
    __bss_end = .;
    __bss_size = __bss_end - __bss_start;

    __end = .;
}