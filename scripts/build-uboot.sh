#!/bin/bash
set -e

VER=$1
DEV=$2
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

# Patch for SSL 1.1 api changes. Why we need to do this I don't understand.
if [ $VER == "2017.4" ]; then
	patch -N -p1 < ../../patches/tools_mkimage_patches_210-openssl-1.1.x-compat.patch || true
fi

make $DEV
time make -j$NP
