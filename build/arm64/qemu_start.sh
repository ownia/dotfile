#!/bin/bash

#qemu-system-aarch64 \
/home/weiouy01/code/qemu/build/qemu-system-aarch64 \
	-machine virt -cpu max \
	-nographic -smp 4 -m 4096 \
	-bios "/home/weiouy01/code/u-boot/u-boot.bin" \
	-kernel arch/arm64/boot/Image \
	-append "rw console=ttyAMA0 kgdboc=tty0,115200" \
	-initrd "/home/weiouy01/code/rootfs.cpio" \
	-device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-fsdev local,security_model=passthrough,id=fsdev0,path=./tmp \
	#-bios "/home/weiouy01/code/RELEASEAARCH64_QEMU_EFI.fd" \
	#-serial pty
	#-S -gdb tcp::8888
