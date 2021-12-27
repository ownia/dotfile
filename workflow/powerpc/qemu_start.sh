qemu-system-ppc64 -M pseries -cpu POWER7 -m 2048 -kernel vmlinux  --append "rw console=hvc0 root=/dev/ram loglevel=7" -boot d -nographic -hda pcc.qcow2
