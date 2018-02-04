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

