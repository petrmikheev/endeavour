#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

wget https://www.nano-editor.org/dist/v8/nano-8.0.tar.gz
tar xzf nano-8.0.tar.gz
cd nano-8.0

export PATH=$PATH:$TOOLCHAIN/bin
./configure --prefix="/usr" --enable-utf8 --host=riscv32-unknown-linux-gnu CFLAGS="-I$TOOLS_DIR/ncurses-build/usr/include" LDFLAGS="-L$TOOLS_DIR/ncurses-build/usr/lib"
make -j$(nproc) && make install DESTDIR=$TOOLS_DIR/nano-build
