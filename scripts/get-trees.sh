#!/bin/bash
mkdir -p trees
cd trees
git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
git clone https://github.com/Xilinx/u-boot-xlnx.git
git clone https://github.com/Xilinx/linux-xlnx.git
git clone https://github.com/Xilinx/device-tree-xlnx.git
wget http://os.archlinuxarm.org/os/ArchLinuxARM-zedboard-latest.tar.gz
