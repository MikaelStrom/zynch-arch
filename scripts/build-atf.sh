#!/bin/bash
set -e

VER=$1
VERSION=xilinx-v$VER
NP=`nproc`

echo Building Arm Trusted Firmware for $VERSION

source scripts/tools.sh $VER
cd trees/arm-trusted-firmware/

if [ `git describe --tags` != $VERSION ]; then
	echo Checking out kernel version $VERSION
	git clean -dxf
	git checkout $VERSION
fi

make ARCH=aarch64 distclean
make ARCH=aarch64 PLAT=zynqmp ZYNQMP_CONSOLE=cadence0 RESET_TO_BL31=1 bl31
