###############################################################################
# Build QEMU
###############################################################################
qemu_root = $(PWD)/qemu
qemu_src = $(qemu_root)/src
qemu_build = $(qemu_root)/build
qemu_dtc =  $(qemu_src)/dtc
qemu_ver = stable-2.5

qemu_clone:
	mkdir -p $(qemu_build)
	test -d $(qemu_src) || git clone git://git.qemu-project.org/qemu.git $(qemu_src)
	cd $(qemu_src) && git checkout -b $(qemu_ver) origin/$(qemu_ver)
	cd $(qemu_src) && ( test -d $(qemu_dtc) && git submodule update --init dtc)


qemu_conf:
	test -d $(qemu_build) || mkdir -p $(qemu_build)
	cd $(qemu_build) && $(qemu_src)/configure  \
    --target-list="aarch64-softmmu"  \
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
xcc_dir = gcc-linaro-4.9-2015.05-x86_64_aarch64-elf
tar_pkg = $(xcc_dir).tar.xz
src_link = https://releases.linaro.org/15.05/components/toolchain/binaries/aarch64-elf/$(tar_pkg)
xcc	=	/opt/$(xcc_dir)/bin/aarch64-elf-

setup_toolchain:
	@test -d /opt || sudo mkdir /opt
	@cd /opt && (test -e $(tar_pkg) || wget $(src_link))
	@cd /opt && (test -d $(xcc_dir) ||  tar -xJf $(tar_pkg))


###############################################################################
# Building
###############################################################################
bin_img = hello.bin

build_objects: hello.c startup.s
	$(xcc)gcc -c -mcpu=cortex-a57 -s -g hello.c -o hello.o
	$(xcc)as -mcpu=cortex-a57 -g startup.s -o startup.o

link_objects: hello.o startup.o
	$(xcc)ld -T startup.ld $^ -o hello.elf
	$(xcc)objcopy -O binary hello.elf $(bin_img)

clean:
	rm -f hello.o startup.o hello.elf

###############################################################################
# RUN
###############################################################################
run:
		$(qemu_build)/aarch64-softmmu/qemu-system-aarch64 \
		-M virt \
		-m 128M \
		-nographic \
		-cpu cortex-a57 \
		-kernel $(bin_img)
