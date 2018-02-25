#!/bin/bash
set -e

KERNEL=$1

mkdir -p sdcard/boot

read -n1 -r -p "Make sure SD-card boot partition (FAT) is mounted on sdcard/boot. Press 'y' to proceed..." key

if [ "$key" != 'y' ]; then
	exit 0
fi

cp -f boot/boot.bin sdcard/boot
cp -f dt/devicetree.dtb sdcard/boot
cp -f $KERNEL sdcard/boot

cat > sdcard/boot/uEnv.txt <<- EOM
uenvcmd=run sdboot
sdboot=mmcinfo && fatload mmc 0 0x3000000 ${kernel_image} && fatload mmc 0 0x2A00000 ${devicetree_image} && bootm 0x3000000 - 0x2A00000
bootargs=console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait
EOM

sync