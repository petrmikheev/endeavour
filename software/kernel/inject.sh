#!/bin/bash

DST=$1

grep endeavour "${DST}"/drivers/Makefile > /dev/null || echo "obj-y += endeavour/" >> "${DST}"/drivers/Makefile
grep endeavour "${DST}"/Kconfig > /dev/null || echo 'source "drivers/endeavour/Kconfig"' >> "${DST}"/Kconfig
rm -rf "${DST}"/drivers/endeavour
cp -r drivers_endeavour "${DST}"/drivers/endeavour

# cross compile for riscv:
# make -j12 ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-
