qemu-system-mips64el -cpu I6400 -M malta -smp 8 -kernel vmlinux -m 2048 -nographic --append "rw console=tty0 root=/dev/ram loglevel=8"
