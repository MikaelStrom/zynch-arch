#!/bin/bash
set -e

VER=$1
VKERNEL=xilinx-v$VER

echo Building kernel $VKERNEL

source scripts/tools.sh $VER
cd trees/linux-xlnx/

if [ `git describe --tags` != $VKERNEL ]; then
	echo Checking out kernel version $VKERNEL
	git clean -dxf
	git checkout $VKERNEL
fi

make ARCH=arm64 mrproper
make ARCH=arm64 xilinx_zynqmp_defconfig
time make -j`nproc` ARCH=arm64
make ARCH=arm64 modules
make ARCH=arm64 INSTALL_MOD_PATH=target modules_install
