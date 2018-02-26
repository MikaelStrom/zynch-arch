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

cat > sdcard/boot/uEnv.txt <<- EOM
uenvcmd=run arch_sdboot
arch_sdboot=echo Copying Linux from SD to RAM... && fatload mmc 0 0x3000000 ${kernel_image} && fatload mmc 0 0x2A00000 ${devicetree_image} && if fatload mmc 0 0x2000000 ${ramdisk_image}; then bootm 0x3000000 0x2000000 0x2A00000; else bootm 0x3000000 - 0x2A00000; fi
bootargs=console=ttyPS0,115200 root=/dev/mmcblk0p2 rw earlyprintk rootfstype=ext4 rootwait
EOM

sync
