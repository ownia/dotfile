#!/bin/bash

target=$1
path=$(dirname $(readlink -f "$0"))

if [ "$target" = "arm64" ];
then
	echo "$path"
	ln -s "$path/arm64/build.sh" "build.sh"
	ln -s "$path/arm64/qemu_start.sh" "qemu_start.sh"
fi
