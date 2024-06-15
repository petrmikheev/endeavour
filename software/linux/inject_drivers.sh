#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DST=$1

grep endeavour "${DST}"/drivers/Makefile > /dev/null || echo "obj-y += endeavour/" >> "${DST}"/drivers/Makefile
grep endeavour "${DST}"/Kconfig > /dev/null || echo 'source "drivers/endeavour/Kconfig"' >> "${DST}"/Kconfig
rm -rf "${DST}"/drivers/endeavour
cp -r $SCRIPT_DIR/drivers_endeavour "${DST}"/drivers/endeavour
#cp ../../extern/core_usb_host/linux/ue11-hcd.c "${DST}"/drivers/endeavour/
#sed -i 's/, is_out)/)/g' "${DST}"/drivers/endeavour/ue11-hcd.c

# cross compile for riscv:
# make -j12 ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-
