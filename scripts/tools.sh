#!/bin/bash
set -e

VER=$1
CMD=$2
TCL=$3
ARG1=$4
ARG2=$5
ARG3=$6

PWD=`pwd`
XILINX=/opt/Xilinx

source $XILINX/Vivado/$VER/settings64.sh
source $XILINX/Vitis/$VER/settings64.sh

# needed for u-boot (dtc headers) and kernel (mkimage to create uImage)
export PATH=$PWD/trees/dtc:$PWD/trees/u-boot-xlnx/tools:$PATH

export CROSS_COMPILE=aarch64-linux-gnu-

# Optional xilinx command, i.e. vivado, hci etc
if [[ $CMD == "xsct" ]]; then
	$CMD $TCL $ARG1 $ARG2 $ARG3
elif [ $CMD ]; then
	$CMD -nojournal -nolog -mode batch -source $TCL -tclargs $ARG1 $ARG2 $ARG3
fi
