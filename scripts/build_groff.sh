#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

wget https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz
tar xzf groff-1.22.4.tar.gz
cd groff-1.22.4

export PATH=$PATH:$TOOLCHAIN/bin
./configure --host=riscv32-unknown-linux-gnu --prefix=/usr && make -j$(nproc)

# NOTE: make fails because it tries to run cross-compiled binaries. It is not a big problem since the binaries are already compiled
