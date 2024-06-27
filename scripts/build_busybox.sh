#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

git clone https://git.busybox.net/busybox
cd busybox

cp $SCRIPT_DIR/busybox_config .config
echo "CONFIG_CROSS_COMPILER_PREFIX=\"$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-\"" >> .config
echo "CONFIG_SYSROOT=\"$TOOLCHAIN/sysroot\"" >> .config

sed -i 's/"less"/"less -R"/g' miscutils/man.c

make -j$(nproc)
