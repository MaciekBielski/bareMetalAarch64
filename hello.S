	.section .rodata
uart0_dr:
	.word 0x09000000
foo:	.asciz "Foo\n"
	.balign 4

	.text
	.global _entry
_entry:
	adr	x9, uart0_dr
	ldr	w9, [x9]
	mov	x10, #0x41
	str	x10, [x9]
	adrp	x11, foo
	adr	x12, foo
	.fail	600
	b .
