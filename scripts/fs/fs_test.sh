FS_TARGET=""
FS_TARGET_TEST=0
FS_MNT="test"
FS_MNT_IMG="test.img"

## check fs target
if [ $# -lt 1 ]; then
	exit
else
	FS_TARGET=$1
	if [[ $# -eq 2 && $2 = "test" ]]; then
		FS_TARGET_TEST=1
	fi
	echo "filesystem: $FS_TARGET"
fi

## build fs
make -C /lib/modules/$(uname -r)/build/ M=$(pwd) modules

if [ -e $FS_MNT ]; then
	:
else
	mkdir -p $FS_MNT
fi

## mount fs
if [ -e $FS_MNT_IMG ]; then
	:
else
	dd if=/dev/zero of=$FS_MNT_IMG bs=1M count=100
fi
sudo umount test
sudo rmmod $FS_TARGET
sudo insmod $FS_TARGET.ko
if [ $FS_TARGET = "ext4" ]; then
	mkfs.ext4 $FS_MNT_IMG
elif [ $FS_TARGET = "erofs" ]; then
	mkfs.erofs -z lz4 -d2 $FS_MNT_IMG $(pwd)
elif [ $FS_TARGET = "minix" ]; then
	mkfs.minix -c $FS_MNT_IMG
elif [ $FS_TARGET = "simplefs" ]; then
	./mkfs.simplefs $FS_MNT_IMG
fi
sudo mount -o loop -t $FS_TARGET $FS_MNT_IMG $FS_MNT

## fs tests
if [ $FS_TARGET_TEST -eq 1 ]; then
	if [ $FS_TARGET = "erofs" ]; then
		sudo dmesg -C
		cat $FS_MNT/* > /dev/null
		sudo dmesg -c
	fi
fi
