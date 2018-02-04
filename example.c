
volatile unsigned int * UART0DR = (unsigned int *)0x09000000;
volatile char *txt[] = {
	"Hello world\n", "Foo bar\n", "Goodbye\n"
};

void print_uart0(const volatile char *s)
{
    for(; *s!='\0'; s++)
        *UART0DR = (unsigned int)(*s); /* Transmit char */
}

static int trampoline(short a)
{
	volatile char *banner;

	switch(a) {
		case 4:
			banner = txt[0];
			break;
		case 2:
			banner = txt[1];
			break;
		case 1:
			banner = txt[2];
			break;
	}

    print_uart0(banner);
}

void c_entry()
{
	unsigned short v = 4;

	trampoline(v);
	v >>= 1;
	trampoline(v);
	v >>= 1;
	trampoline(v);
}
