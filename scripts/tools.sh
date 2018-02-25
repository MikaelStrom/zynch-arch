#!/bin/bash
set -e

VER=$1
CMD=$2
TCL=$3
ARG1=$4
ARG2=$5
ARG3=$6

XILINX=/opt/Xilinx

source $XILINX/Vivado/$VER/settings64.sh
source $XILINX/SDK/$VER/settings64.sh

# Older Vivado versions have different tool chains
if [ $VER == "2017.4" ]; then
	export CROSS_COMPILE=arm-linux-gnueabihf-
else
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
fi

# Optional xilinx command, i.e. vivado, hci etc
if [ $CMD ]; then
	$CMD -nojournal -nolog -mode batch -source $TCL -tclargs $ARG1 $ARG2 $ARG3
fi
