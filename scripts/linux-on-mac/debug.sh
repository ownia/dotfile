qemu-system-aarch64 \
  -m 4G \
  -display default,show-cursor=on \
  -device virtio-rng-pci \
  -machine type=virt,accel=hvf,highmem=off \
  -smp 4 \
  -drive file=linux.qcow2,if=virtio \
  -cpu host \
  -nographic \
  -usb -device usb-ehci \
  -bios u-boot.bin \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::2222-:22 \
  -s -S \
#  -pflash flash0.img \
#  -cdrom ubuntu-21.10-live-server-arm64.iso \
