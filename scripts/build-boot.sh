#!/bin/bash
set -e

VER=$1
BIT=$2
FSBL=$3
UBOOT=$4
KERNEL=$5

source scripts/tools.sh $VER

mkdir -p boot

cp -f $BIT boot/zynq.bit
cp -f $FSBL boot/fsbl.elf
cp -f $UBOOT boot/u-boot.elf
cp -f $KERNEL boot/uImage

cat > boot/image.bif <<- EOM
image: {
  [bootloader]./fsbl.elf
  ./zynq.bit
  ./u-boot.elf
}
EOM

cd boot
bootgen -w -image image.bif -o i boot.bin
