#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

# config
#make defconfig
# build
make -j"$(nproc)"
