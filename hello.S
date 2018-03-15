	.section .rodata
uart0_dr:
	.word	0x09000000
foo:	.asciz	"Foo\n"
	.balign	8
g:	.xword	0x8182838485868788
h:	.8byte	0xddddddddeeeeeeee

	.text
	.global _entry
_entry:
	mrs	x11, RVBAR_EL3

	adr	x9, g
	ldr	x9, [x9]

	adrp	x10, g
	add	x10, x10, :lo12:g
	ldr	x10, [x10]

	stp	x9, x10, [sp, -16]!

	.fail	600
	b .
