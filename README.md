Inspired by:
https://github.com/freedomtan/aarch64-bare-metal-qemu


Running bare metal HelloWorld on QEMU 'virt' machine

* Assumed linaro cross-toolchain used
* UART address
    [VIRT_UART] = { 0x09000000, 0x00001000 },
* binary image is passed to `-kernel` option is loaded at `0x40000000`

### Running
Follow the steps form Makefile

$ make qemu_clone
$ make qemu_conf
$ make qemu_build
$ make setup_toolchain
$ make build_objects
$ make link_objects
$ make run


### Overview
Coppied from:
https://github.com/matja/asm-examples/blob/master/aarch64/overview.txt

Bottom 32-bits of registers are w0..w31

x0..x7   : arguments and return value
x8       : indirect result (struct) location
x9..x15  : temporary registers
x16..x17 : intra-call-user registers (PLT, linker)
x18      : platform specific use (TLS)
x19-x28  : callee-saved registers
x29      : frame pointer
x30(lr)  : link register
x31(sp)  : stack pointer / read zero

32x 32-bit single precision float registers : s0..s31
32x 64-bit double precision float registers : d0..d31
32x 128-bit SIMD registers : v0..v31

s0..s31 is the bottom 32-bits of d0..d31
d0..d31 is the bottom 64-bits of v0..v31

v0..v7   : arguments and return value
d8..d15  : callee saved registers
v16..v31 : temporary registers
bits 64..127 not saved on v8-v15

Memory :
Unaligned addresses are permitted for most loads and stores, with the
exception of exclusive and ordered accesses.

Memory is weakly ordered - writes can occur in any order, use barriers:
dmb - data memory barrier
dsb - data synchronization barrier
isb - instruction synchronization barrier

Instruction aliases :
ret = ret x30 (subroutine return hint)

