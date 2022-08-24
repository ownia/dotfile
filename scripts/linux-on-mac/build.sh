qemu-system-aarch64 \
  -m 4G \
  -display default,show-cursor=on \
  -machine type=virt,accel=hvf,highmem=off \
  -cdrom ubuntu-21.10-live-server-arm64.iso \
  -smp 4 \
  -drive file=linux.qcow2,if=virtio \
  -cpu host \
  -nographic \
  -usb -device usb-ehci \
  -pflash flash0.img \
#  -net nic,model=virtio \
#  -net user,hostfwd=tcp::2222-:22 \
#  -bios u-boot.bin \
#  -device virtio-rng-pci \
