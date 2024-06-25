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
mkdir -p rootfs/usr/share
cp -r $TOOLCHAIN/sysroot/lib rootfs/
cp -r $TOOLCHAIN/sysroot/sbin/* rootfs/sbin/
cp -r $TOOLCHAIN/sysroot/usr/{bin,include,lib,libexec} rootfs/usr/
cp -r $TOOLCHAIN/native/include/* rootfs/usr/include/
cp -r $TOOLCHAIN/native/lib/gcc rootfs/usr/lib/
#cp -r $TOOLCHAIN/native/lib/gcc/riscv32-unknown-linux-gnu/13.2.0/include/* rootfs/usr/include/
cp -r $TOOLCHAIN/native/share/* rootfs/usr/share/
cp -r $TOOLCHAIN/native/libexec/* rootfs/usr/libexec/
cp -r $TOOLCHAIN/native/bin/{ar,objcopy,gfortran,gprof,elfedit,gcc,strip,readelf,as,gcc-ranlib,c++filt,size,addr2line,objdump,gdbserver,g++,gcov,ranlib,gcc-nm,nm,strings,gcc-ar,gcov-tool,cpp,ld} rootfs/usr/bin/
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip -d rootfs/usr/bin/{ar,objcopy,gfortran,gprof,elfedit,gcc,strip,readelf,as,gcc-ranlib,c++filt,size,addr2line,objdump,gdbserver,g++,gcov,ranlib,gcc-nm,nm,strings,gcc-ar,gcov-tool,cpp,ld}
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip -d $(find rootfs/usr/libexec -type f) 2> /dev/null
sed -i 's/#!\/bin\/bash/#!\/bin\/sh/g' rootfs/usr/bin/*
