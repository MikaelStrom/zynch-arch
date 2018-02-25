#!/bin/bash
set -e

KERNEL=$1

mkdir -p sdcard/fs

read -n1 -r -p "Make sure SD-card file system partition (EXT4) is mounted on sdcard/fs. Press 'y' to proceed..." key

if [ "$key" != 'y' ]; then
	exit 0
fi

echo ""
echo Copying file sysytem, be patient...

bsdtar -xpf trees/ArchLinuxARM-zedboard-latest.tar.gz -C sdcard/fs
sync
