#!/bin/bash
set -e

VER=$1
DEV=$2
ATF=$3
VUBOOT=xilinx-v$VER
NP=`nproc`
PWD=`pwd`

echo Building U-BOOT $VUBOOT for $DEV

source scripts/tools.sh $VER

cd trees/u-boot-xlnx

if [ `git describe --tags` != $VUBOOT ]; then
	echo Checking out U-BOOT version $VUBOOT
	git clean -dxf
	git checkout $VUBOOT
fi

export ARCH=aarch64
make distclean
make $DEV
export DEVICE_TREE="avnet-ultrazedev-cc-v1.0-ultrazedev-som-v1.0"
time make -j$NP
