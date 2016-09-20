
volatile unsigned int * const UART0DR = (unsigned int *)0x09000000;
 
void print_uart0(const char *s)
{
    for(; *s!='\0'; s++)
        *UART0DR = (unsigned int)(*s); /* Transmit char */
}
 
void c_entry()
{
    print_uart0("Hello world!\n");
}
