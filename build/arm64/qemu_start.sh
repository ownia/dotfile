qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 4 -m 4096 -kernel arch/arm64/boot/Image --append "rw console=ttyAMA0 loglevel=8 no_hash_pointers memblock console=tty0 kgdboc=tty0,115200 root=/dev/vda" -append nokaslr \
-device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hostshare -fsdev local,security_model=passthrough,id=fsdev0,path=./tmp \
#-serial pty
#-S -gdb tcp::8888
