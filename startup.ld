/* With QEMU this is not needed */
/* ENTRY(_Reset) */
SECTIONS
{
    /*
	 * QEMU bootloader will put it on 0x40080000 anyway, this is needed for
	 * sections laying down, not loading
     */
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
