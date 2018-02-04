	.arch armv8-a+crc
	.file	"example.c"
	.global	UART0DR
	.data
	.align	3
	.type	UART0DR, %object
	.size	UART0DR, 8
UART0DR:
	.xword	150994944
	.global	txt
	.section	.rodata
	.align	3
.LC0:
	.string	"Hello world\n"
	.align	3
.LC1:
	.string	"Foo bar\n"
	.align	3
.LC2:
	.string	"Goodbye\n"
	.data
	.align	3
	.type	txt, %object
	.size	txt, 24
txt:
	.xword	.LC0
	.xword	.LC1
	.xword	.LC2
	.text
	.align	2
	.global	print_uart0
	.type	print_uart0, %function
print_uart0:
	sub	sp, sp, #16
	str	x0, [sp, 8]
	b	.L2
.L3:
	adrp	x0, UART0DR
	add	x0, x0, :lo12:UART0DR
	ldr	x0, [x0]
	ldr	x1, [sp, 8]
	ldrb	w1, [x1]
	and	w1, w1, 255
	str	w1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 1
	str	x0, [sp, 8]
.L2:
	ldr	x0, [sp, 8]
	ldrb	w0, [x0]
	and	w0, w0, 255
	cmp	w0, 0
	bne	.L3
	nop
	add	sp, sp, 16
	ret
	.size	print_uart0, .-print_uart0
	.align	2
	.type	trampoline, %function
trampoline:
	stp	x29, x30, [sp, -48]!
	add	x29, sp, 0
	strh	w0, [x29, 30]
	ldrsh	w0, [x29, 30]
	cmp	w0, 2
	beq	.L6
	cmp	w0, 4
	beq	.L7
	cmp	w0, 1
	beq	.L8
	b	.L5
.L7:
	adrp	x0, txt
	add	x0, x0, :lo12:txt
	ldr	x0, [x0]
	str	x0, [x29, 40]
	b	.L5
.L6:
	adrp	x0, txt
	add	x0, x0, :lo12:txt
	ldr	x0, [x0, 8]
	str	x0, [x29, 40]
	b	.L5
.L8:
	adrp	x0, txt
	add	x0, x0, :lo12:txt
	ldr	x0, [x0, 16]
	str	x0, [x29, 40]
	nop
.L5:
	ldr	x0, [x29, 40]
	bl	print_uart0
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	trampoline, .-trampoline
	.align	2
	.global	c_entry
	.type	c_entry, %function
c_entry:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	mov	w0, 4
	strh	w0, [x29, 30]
	ldrsh	w0, [x29, 30]
	bl	trampoline
	ldrh	w0, [x29, 30]
	lsr	w0, w0, 1
	strh	w0, [x29, 30]
	ldrsh	w0, [x29, 30]
	bl	trampoline
	ldrh	w0, [x29, 30]
	lsr	w0, w0, 1
	strh	w0, [x29, 30]
	ldrsh	w0, [x29, 30]
	bl	trampoline
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	c_entry, .-c_entry
	.ident	"GCC: (Linaro GCC 6.3-2017.05) 6.3.1 20170404"
