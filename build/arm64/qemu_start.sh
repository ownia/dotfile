#!/bin/bash

qemu-system-aarch64 \
	-machine virt -cpu cortex-a710 \
	-bios "/home/weiouy01/code/RELEASEAARCH64_QEMU_EFI.fd" \
	-nographic -smp 4 -m 4096 \
	-kernel arch/arm64/boot/Image \
	-append "rw console=ttyAMA0 kgdboc=tty0,115200" \
	-initrd "/home/weiouy01/code/rootfs.cpio" \
	-device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-fsdev local,security_model=passthrough,id=fsdev0,path=./tmp \
	#-serial pty
	#-S -gdb tcp::8888
