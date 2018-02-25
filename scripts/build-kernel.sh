#!/bin/bash
set -e

VER=$1
VKERNEL=xilinx-v$VER
NP=`nproc`

echo Building kernel $VKERNEL

source scripts/tools.sh $VER
cd trees/linux-xlnx/

if [ `git describe --tags` != $VKERNEL ]; then
	echo Checking out kernel version $VKERNEL
	git clean -dxf
	git checkout $VKERNEL
fi

# We need u-boot's mkimage in path when building kernel, otherwise uImage is not generated
export PATH=../u-boot-xlnx/tools:$PATH

make ARCH=arm mrproper
make ARCH=arm xilinx_zynq_defconfig
time make -j$NP ARCH=arm UIMAGE_LOADADDR=0x8000 uImage
make ARCH=arm modules
make ARCH=arm INSTALL_MOD_PATH=target modules_install
