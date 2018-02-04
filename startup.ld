ENTRY(_Reset)
SECTIONS
{
    /* this is from virt.c */
    . = 0x40000000;
    /* put INTERRUPT_VECTOR and then rest of the code */
    .text : {
        startup.o (INTERRUPT_VECTOR)
        *(.text)
    }
    .data : {
    	*(.data)
    	*(.rodata)
    }
    .bss : { *(.bss COMMON) }
    . = ALIGN(8);
    . = . + 0x1000; /* 4kB of stack memory */
    stack_top = .;  /* stack grows backward towards .bss */
}
