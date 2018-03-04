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
cp -f dt/devicetree.dtb sdcard/boot
cp -f $KERNEL sdcard/boot

cat > sdcard/boot/uenv.txt <<- EOM
uenvcmd=run sdboot
sdboot=echo Copying Arch Linux from SD to RAM... && mmcinfo && fatload mmc 0 0x3000000 \${kernel_image} && fatload mmc 0 0x2A00000 \${devicetree_image} && bootm 0x3000000 - 0x2A00000
bootargs=console=ttyPS0,115200 root=/dev/mmcblk0p2 rw earlyprintk rootfstype=ext4 rootwait
EOM

sync
