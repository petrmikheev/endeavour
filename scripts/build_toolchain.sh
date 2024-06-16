#!/bin/bash

# Deps for debian/ubuntu
# sudo apt-get install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools

mkdir -p $TOOLS_DIR
cd $TOOLS_DIR

git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --prefix=$TOOLS_DIR/rv32imac-linux-toolchain --with-arch=rv32imac --with-abi=ilp32
make -j$(nproc) linux-native
