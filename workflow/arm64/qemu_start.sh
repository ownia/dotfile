qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 4 -m 4096 -kernel arch/arm64/boot/Image --append "rw console=ttyAMA0 loglevel=8 no_hash_pointers memblock console=tty0 kgdboc=tty0,115200" -append nokaslr \
#-serial pty
#-S -gdb tcp::8888
