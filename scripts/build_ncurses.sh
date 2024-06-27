#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_DIR=$SCRIPT_DIR/../../endeavour-tools
TOOLCHAIN=$TOOLS_DIR/rv32imac-linux-toolchain

cd $TOOLS_DIR

wget https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz
tar xzf ncurses-6.5.tar.gz
cd ncurses-6.5

export PATH=$PATH:$TOOLCHAIN/bin
./configure --host=riscv32-unknown-linux-gnu --with-strip-program=riscv32-unknown-linux-gnu-strip --with-termlib
make -j$(nproc) && make install DESTDIR=$TOOLS_DIR/ncurses-build

cd ../ncurses-build/usr/include
ln -s . ncursesw
cd ../lib
ln -s libtinfow.a libtinfo.a
