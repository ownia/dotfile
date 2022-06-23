qemu-system-arm -M vexpress-a9 -smp 4 -m 1024M -kernel arch/arm/boot/zImage -dtb arch/arm/boot/dts/vexpress-v2p-ca9.dtb -nographic -append "rw loglevel=8 console=ttyAMA0 root=/dev/mmcblk0 no_hash_pointers" -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare -fsdev local,security_model=passthrough,id=fsdev0,path=./share \
2>&1 | tee kfence_test3.log
#-S -gdb tcp::8889 \
