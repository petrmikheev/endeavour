#!/bin/bash

CONTENT=$1
IMAGE=$2

dd if=/dev/zero of=$IMAGE count=8192
mkfs.ext2 $IMAGE
mkdir tmp_$IMAGE
sudo mount -o loop $IMAGE tmp_$IMAGE
sudo cp -r $CONTENT/* tmp_$IMAGE/
sudo umount $IMAGE
rmdir tmp_$IMAGE
