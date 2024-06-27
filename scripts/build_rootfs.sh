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
mkdir -p rootfs/usr/share
cp -r $TOOLCHAIN/sysroot/lib rootfs/
cp -r $TOOLCHAIN/sysroot/sbin/* rootfs/sbin/
cp -r $TOOLCHAIN/sysroot/usr/{bin,include,lib,libexec} rootfs/usr/
cp -r $TOOLCHAIN/native/include/* rootfs/usr/include/
cp -r $TOOLCHAIN/native/lib/gcc rootfs/usr/lib/
#cp -r $TOOLCHAIN/native/lib/gcc/riscv32-unknown-linux-gnu/13.2.0/include/* rootfs/usr/include/
cp -r $TOOLCHAIN/native/share/{gcc*,man} rootfs/usr/share/
cp -r $TOOLCHAIN/native/libexec/* rootfs/usr/libexec/
cp -r $TOOLCHAIN/native/bin/{ar,objcopy,gfortran,gprof,elfedit,gcc,strip,readelf,as,gcc-ranlib,c++filt,size,addr2line,objdump,gdbserver,g++,gcov,ranlib,gcc-nm,nm,strings,gcc-ar,gcov-tool,cpp,ld} rootfs/usr/bin/
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip rootfs/usr/bin/{ar,objcopy,gfortran,gprof,elfedit,gcc,strip,readelf,as,gcc-ranlib,c++filt,size,addr2line,objdump,gdbserver,g++,gcov,ranlib,gcc-nm,nm,strings,gcc-ar,gcov-tool,cpp,ld}
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip -d $(find rootfs/usr/libexec -type f) 2> /dev/null
sed -i 's/#!\/bin\/bash/#!\/bin\/sh/g' rootfs/usr/bin/*

cp groff-1.22.4/{groff,grotty,nroff,tbl,troff} rootfs/usr/bin/
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip rootfs/usr/bin/{groff,grotty,tbl,troff}
mkdir -p rootfs/usr/share/groff/1.22.4/font
cp -r groff-1.22.4/font/devascii rootfs/usr/share/groff/1.22.4/font/devascii
cp -r groff-1.22.4/tmac rootfs/usr/share/groff/1.22.4/tmac
sed -i 's/.mso man.local/.\\"msi man.local/g' rootfs/usr/share/groff/1.22.4/tmac/an-old.tmac

mkdir -p rootfs/usr/share/man/man1
mkdir -p rootfs/usr/share/man/man5
mkdir -p rootfs/usr/share/man/man7

cp ncurses-build/usr/share/man/man1/* rootfs/usr/share/man/man1/
cp ncurses-build/usr/share/man/man5/* rootfs/usr/share/man/man5/
cp ncurses-build/usr/share/man/man7/* rootfs/usr/share/man/man7/
cp -r ncurses-build/usr/share/{tabset,terminfo} rootfs/usr/share/
cp -d ncurses-build/usr/include/* rootfs/usr/include/
cp ncurses-build/usr/bin/* rootfs/usr/bin/
cp -d ncurses-build/usr/lib/* rootfs/usr/lib/

cp nano-build/usr/bin/* rootfs/usr/bin
$TOOLCHAIN/bin/riscv32-unknown-linux-gnu-strip rootfs/usr/bin/nano
cp nano-build/usr/share/man/man1/* rootfs/usr/share/man/man1/
cp nano-build/usr/share/man/man5/* rootfs/usr/share/man/man5/
cp -r nano-build/usr/share/nano rootfs/usr/share/nano
echo 'include "/usr/share/nano/*.nanorc"' > rootfs/etc/nanorc

if [ ! -d terminus-font-4.49.1 ] ; then
    wget http://downloads.sourceforge.net/project/terminus-font/terminus-font-4.49/terminus-font-4.49.1.tar.gz
    tar xzf terminus-font-4.49.1.tar.gz
fi

mkdir -p rootfs/usr/share/fonts
cp terminus-font-4.49.1/ter-u{12,14,16}*.bdf rootfs/usr/share/fonts
