#!/bin/bash

#qemu-system-aarch64 \
/data_sda/qemu/build/qemu-system-aarch64 \
	-machine virt -cpu max \
	-nographic -smp 4 -m 4096 \
	-kernel arch/arm64/boot/Image \
	-append "rootwait root=/dev/vda" \
	-drive file=rootfs.ext4,if=none,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	-device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-fsdev local,security_model=passthrough,id=fsdev0,path=./tmp \
	#-bios "/home/weiouy01/code/RELEASEAARCH64_QEMU_EFI.fd" \
	#-serial pty
	#-S -gdb tcp::8888
