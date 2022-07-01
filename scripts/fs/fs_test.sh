FS_TARGET=""
FS_TARGET_TEST=0
FS_MNT="test"
FS_MNT_IMG="test.img"

## https://zonedstorage.io/docs/getting-started/nullblk
FS_ZONEFS_DEVICE=""

function fs_clean() {
	sudo umount $FS_MNT
	sudo rmmod $FS_TARGET
}

## check fs target
if [ $# -lt 1 ]; then
	exit
else
	FS_TARGET=$1
	if [ $# -eq 2 ]; then
		if [ $2 = "test" ]; then
			FS_TARGET_TEST=1
		elif [ $2 = "clean" ]; then
			fs_clean
			exit
		fi
	fi
	echo "filesystem: $FS_TARGET"
fi

## build fs
if [ $FS_TARGET = "simplefs" ]; then
	make
else
	make -C /lib/modules/$(uname -r)/build/ M=$(pwd) modules
fi

## mount fs
if [ -e $FS_MNT ]; then
	:
else
	mkdir -p $FS_MNT
fi
if [ -e $FS_MNT_IMG ]; then
	:
else
	dd if=/dev/zero of=$FS_MNT_IMG bs=1M count=100
fi
fs_clean
sudo insmod $FS_TARGET.ko
if [ $FS_TARGET = "ext4" ]; then
	mkfs.ext4 $FS_MNT_IMG
elif [ $FS_TARGET = "erofs" ]; then
	mkfs.erofs -z lz4 -d2 $FS_MNT_IMG $(pwd)
elif [ $FS_TARGET = "f2fs" ]; then
	mkfs.f2fs -f $FS_MNT_IMG
elif [ $FS_TARGET = "minix" ]; then
	mkfs.minix -c $FS_MNT_IMG
elif [ $FS_TARGET = "zonefs" ]; then
	sudo modprobe null_blk nr_devices=1 zoned=1
	FS_ZONEFS_DEVICE="/dev/nullb0"
	sudo mkfs.zonefs $FS_ZONEFS_DEVICE
elif [ $FS_TARGET = "simplefs" ]; then
	./mkfs.simplefs $FS_MNT_IMG
fi
if [ $FS_TARGET = "zonefs" ]; then
	sudo mount -t $FS_TARGET $FS_ZONEFS_DEVICE $FS_MNT
else
	sudo mount -o loop -t $FS_TARGET $FS_MNT_IMG $FS_MNT
fi

## fs tests
if [ $FS_TARGET_TEST -eq 1 ]; then
	if [ $FS_TARGET = "erofs" ]; then
		sudo dmesg -C
		cat $FS_MNT/* > /dev/null
		sudo dmesg -c
	fi
fi
