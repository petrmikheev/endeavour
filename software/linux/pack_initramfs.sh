#!/bin/bash

cd initramfs
find . | cpio -H newc -R root:root -o | gzip > ../initramfs.img
cd ..
