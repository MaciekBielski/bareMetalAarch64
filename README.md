Inspired by:
https://github.com/freedomtan/aarch64-bare-metal-qemu


Running bare metal HelloWorld on QEMU 'virt' machine

* Assumed linaro cross-toolchain used
* UART address
    [VIRT_UART] = { 0x09000000, 0x00001000 },
* binary image is passed to `-kernel` option is loaded at `0x00010000`

### Files
- `startup.s` is the first program run
- `hello.c` is a binary to jump to on reset
- `startup.ld` is a linker script to build a binary from `hello.o` and
  `startup.o`

### Running
Follow the steps form Makefile

$ make qemu_clone
$ make qemu_conf
$ make qemu_build
$ make setup_toolchain
$ make build_objects
$ make link_objects
$ make run
