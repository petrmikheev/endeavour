#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

mkdir -p $TOOLS_DIR
cd $TOOLS_DIR

#wget https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-13.3.0/gcc-13.3.0.tar.xz
#tar -xf gcc-13.3.0.tar.xz
#cd gcc-13.3.0
#./contrib/download_prerequisites
#cd ..
mkdir gcc-build
cd gcc-build
export PATH=$PATH:$TOOLCHAIN/bin
export CC=riscv32-unknown-linux-gnu-gcc
../gcc-13.3.0/configure --host=riscv32-unknown-linux-gnu --with-sysroot=$TOOLCHAIN/sysroot

#./configure --prefix=$TOOLS_DIR/rv32imac-linux-toolchain --with-arch=rv32imac --with-abi=ilp32
make -j$(nproc)
