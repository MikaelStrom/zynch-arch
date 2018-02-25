# Generic makefile for creating Zynq boot images on SD card
#
# VER below corresponds to Vivado release number.

VER = 2017.4
UBOOT_DEV = zynq_zed_config
#UBOOT_DEV = zynq_microzed_config
#UBOOT_DEV = zynq_picozed_config

# Dummy bit stream and hardware description is put here for now.
# Obviously, this makefile should build everything when completed.

BIT = fpga/synth/zynq.bit
HDF = fpga/synth/zynq.hdf

# Section below should be fairly static

KERNEL = trees/linux-xlnx/arch/arm/boot/uImage
UBOOT = trees/u-boot-xlnx/u-boot
FSBL = fsbl/executable.elf
DTS = dt/system-top.dts
DTB = dt/devicetree.dtb
BOOT = boot/boot.bin

boot: $(BOOT) 

$(UBOOT):
	@scripts/build-uboot.sh $(VER) $(UBOOT_DEV)

$(KERNEL): $(UBOOT)
	@scripts/build-kernel.sh $(VER)

$(FSBL): $(HDF)
	@scripts/tools.sh $(VER) hsi scripts/build-fsbl.tcl $(HDF)

$(DTS): $(HDF)
	@scripts/tools.sh $(VER) hsi scripts/build-dts.tcl $(HDF)

$(DTB): $(DTS) $(KERNEL)
	@trees/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o $(DTB) $(DTS)

$(BOOT): $(BIT) $(FSBL) $(UBOOT) $(KERNEL)
	@scripts/build-boot.sh $(VER) $(BIT) $(FSBL) $(UBOOT) $(KERNEL)

# Install on sdcard

sdboot: $(DTB) $(BOOT) 
	@sudo scripts/build-sdboot.sh $(KERNEL)

sdfs: 
	@sudo scripts/build-sdfs.sh $(KERNEL)

# Clean up

distclean:
	@cd trees/u-boot-xlnx && git clean -dxf
	@cd trees/linux-xlnx && git clean -dxf
	@rm -rf fsbl dt boot
