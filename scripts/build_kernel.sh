#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.9.2.tar.xz
tar -xf linux-6.9.2.tar.xz
ln -s linux-6.9.2 linux_kernel

cp $SCRIPT_DIR/../software/linux/kernel_config linux_kernel/.config
$SCRIPT_DIR/../software/linux/inject_drivers.sh linux_kernel

cd linux_kernel
make -j$(nproc) ARCH=riscv CROSS_COMPILE=$TOOLCHAIN/bin/riscv32-unknown-linux-gnu- oldconfig
make -j$(nproc) ARCH=riscv CROSS_COMPILE=$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-
