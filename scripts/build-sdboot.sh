#!/bin/bash
set -e

KERNEL=$1

mkdir -p sdcard/boot

read -n1 -r -p "Make sure SD-card boot partition (FAT) is mounted on sdcard/boot. Press 'y' to proceed..." key
echo ""
if [ "$key" != 'y' ]; then
	exit 0
fi
echo Copying boot files...

cp -f boot/boot.bin sdcard/boot
cp -f boot/devicetree.dtb sdcard/boot
cp -f boot/image.ub sdcard/boot
cp -f boot.scr sdcard/boot

cat > sdcard/boot/uenv.txt <<- EOM
setenv bootargs 'console=ttyPS0,115200 earlycon root=/dev/mmcblk1p2 rw rootwait cma=1500M'
EOM

sync
