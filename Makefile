qemu_root 	= $(PWD)/qemu
qemu_src 	= $(qemu_root)/src
qemu_build 	= $(qemu_root)/build
qemu_dtc 	=  $(qemu_src)/dtc
qemu_ver 	= stable-2.5
cpu_model	= cortex-a53

qgdb_host 	= 127.0.0.1
qgdb_port 	= 2345
xcc_gdb		= /opt/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gdb

###############################################################################
# Build QEMU
###############################################################################
qemu_clone:
	mkdir -p $(qemu_build)
	test -d $(qemu_src) || git clone git://git.qemu-project.org/qemu.git $(qemu_src)
	cd $(qemu_src) && git checkout -b $(qemu_ver) origin/$(qemu_ver)
	cd $(qemu_src) && ( test -d $(qemu_dtc) && git submodule update --init dtc)


qemu_conf:
	test -d $(qemu_build) || mkdir -p $(qemu_build)
	cd $(qemu_build) && $(qemu_src)/configure  \
    --target-list="aarch64-softmmu arm-softmmu"  \
    --enable-debug  \
    --enable-kvm \
	--disable-libusb --disable-sdl \
	--disable-seccomp --disable-numa \
	--disable-spice --disable-archipelago --disable-usb-redir \
	--disable-brlapi --disable-gtk --disable-bluez --disable-rbd \
	--disable-opengl --disable-libiscsi --disable-vde --disable-vnc-png \
	--disable-vnc-sasl --disable-werror

qemu_build:
	make -C $(qemu_build) -j3

###############################################################################
# Toolchain setup
###############################################################################
xcc_dir = gcc-linaro-6.3.1-2017.05-x86_64_aarch64-elf
tar_pkg = $(xcc_dir).tar.xz
src_link = https://releases.linaro.org/15.05/components/toolchain/binaries/aarch64-elf/$(tar_pkg)
xcc	=	/opt/$(xcc_dir)/bin/aarch64-elf-

setup_toolchain:
	@test -d /opt || sudo mkdir /opt
	@cd /opt && (test -e $(tar_pkg) || wget $(src_link))
	@cd /opt && (test -d $(xcc_dir) ||  tar -xJf $(tar_pkg))


###############################################################################
# Building
#
# .S extension for hand-written files, will be run through preprocessor
###############################################################################
bin_img = hello.bin

build_objects: hello.S startup.S
	@$(xcc)as -mcpu=$(cpu_model) -g startup.S -o startup.o
	@$(xcc)as -mcpu=$(cpu_model) -g hello.S -o hello.o

link_objects: hello.o startup.o
	@$(xcc)ld -T startup.ld $^ -o hello.elf
	@$(xcc)objcopy -O binary hello.elf $(bin_img)

clean:
	rm -f hello.o startup.o hello.elf old_hello.s

example:
	@$(xcc)gcc -S -mcpu=$(cpu_model)  \
		-o example.s example.c
###############################################################################
# RUN
###############################################################################
qemu_cmd_args =\
		-M virt \
		-m 128M \
		-nographic \
		-cpu $(cpu_model) \
		-kernel $(bin_img)
run:
		stty intr ^] && \
		$(qemu_build)/aarch64-softmmu/qemu-system-aarch64 $(qemu_cmd_args)

gdb_srv:
	stty intr ^] && \
		$(qemu_build)/aarch64-softmmu/qemu-system-aarch64 \
		-gdb tcp::$(qgdb_port) -S \
		$(qemu_cmd_args)

gdb_cli:
	cgdb -d$(xcc_gdb) -- -q \
		-ex="target remote $(qgdb_host):$(qgdb_port)" \
		-ex="dir $(kernel_dir)" \
		-ex="symbol-file vmlinux" \
		-ex="handle SIGUSR1 stop print nopass"


