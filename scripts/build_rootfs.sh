#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

rm -rf rootfs
cp -r $SCRIPT_DIR/../software/linux/base_rootfs rootfs

cp busybox/busybox rootfs/bin/busybox
cp linux_kernel/arch/riscv/boot/Image rootfs/boot/vmlinux

mkdir -p rootfs/sbin
mkdir -p rootfs/usr
cp -r $TOOLCHAIN/sysroot/lib rootfs/
cp -r $TOOLCHAIN/sysroot/sbin/* rootfs/sbin/
cp -r $TOOLCHAIN/sysroot/usr/{bin,include,lib,libexec} rootfs/usr/

cd gcc-build
make DESTDIR=../rootfs install
cd ..
