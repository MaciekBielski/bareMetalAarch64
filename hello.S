	.section .rodata
	.align	  3
UART0_DR:
	.word	0x09000000
	.align	  3
UART0_LSR:
	.word	0x09000014
	.align	  3

txt:	.asciz	"Welcome\n"
	.balign	8

	.text
	.global _entry
	.align 3
	.type _entry, %function
_entry:
	ldr	x10, =stack_top
	mov	sp, x10
	adr	x0, txt
	bl	pr_uart0
	b	.
	.size	_entry, .-_entry

	/* Print character to the console */
	.align	3
	.type	pr_uart0, %function
pr_uart0:
	sub	sp, sp, #8
	str	x0, [sp, #8]
	adr	x9, UART0_LSR
	ldr	x9, [x9]
	adr	x13, UART0_DR
	ldr	x13, [x13]
	b	_while_lsr

_put_char:
	strb	w12, [x13]
	add	x11, x11, #1
	str	x11, [sp, #8]

_while_lsr:
	/* test if device ready for input */
	ldrh	w10, [x9]
	/* w10 && 0x20  == test 5th bit */
	/* for QEMU tweaked to tbnz just to always pass */
	tbnz	w10, #5, .

	/* pointer mechanics */
	ldr	x11, [sp, #8]
	ldrb	w12, [x11]

	/* check if input is valid (not null) */
	cmp	w12, 0x0
	bne	_put_char
	ret

	add	sp, sp, #8
	.size	   pr_uart0, .-pr_uart0

