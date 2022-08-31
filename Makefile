# Generic makefile for creating Zynq boot images on SD card
#
# VER below corresponds to Vivado release number.

VER = 2021.2
UBOOT_DEV = xilinx_zynqmp_virt_defconfig 

# Dummy bit stream and hardware description is put here for now.
# Obviously, this makefile should build everything when completed.

BIT = fpga/base/base.runs/impl_1/base_wrapper.bit
HDF = fpga/base/base_wrapper.xsa

# Section below should be fairly static

DTC = trees/dtc/dtc
UBOOT = trees/u-boot-xlnx/u-boot
KERNEL = trees/linux-xlnx/arch/arm64/boot/Image
FSBL = fsbl/hw/export/hw/sw/hw/boot/fsbl.elf
PMUFW = fsbl/hw/export/hw/sw/hw/boot/pmufw.elf
ATF = trees/arm-trusted-firmware/build/zynqmp/release/bl31/bl31.elf
DTS = dt/system-top.dts
DTB = dt/devicetree.dtb
BOOT = boot/boot.bin

boot: $(BOOT)

$(DTC):
	@cd trees/dtc && make

$(KERNEL):
	@scripts/build-kernel.sh $(VER)

$(ATF):
	@scripts/build-atf.sh $(VER)

$(UBOOT): $(DTC) $(ATF)
	@scripts/build-uboot.sh $(VER) $(UBOOT_DEV) $(ATF)

$(FSBL): $(KERNEL) $(HDF)	# builds PMUFW
	@scripts/tools.sh $(VER) xsct scripts/build-fsbl.tcl $(HDF)

$(DTS): $(FSBL) $(HDF)
	@scripts/tools.sh $(VER) xsct scripts/build-dts.tcl $(HDF)
	@gcc -I dt -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o $(DTS).pre $(DTS)
	@mv $(DTS).pre $(DTS)

$(DTB): $(DTS) $(KERNEL)
	@patch -p1 -N < patches/system-top.dts.patch
	@trees/linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o $(DTB) $(DTS)

$(BOOT): $(BIT) $(ATF) $(FSBL) $(PMUFW) $(UBOOT) $(DTB) $(KERNEL)
	@scripts/build-boot.sh $(VER) $(BIT) $(ATF) $(FSBL) $(PMUFW) $(UBOOT) $(DTB) $(KERNEL)

# Install on sdcard

sdboot: $(DTB) $(BOOT)
	@sudo scripts/build-sdboot.sh $(KERNEL)

sdfs:
	@sudo scripts/build-sdfs.sh $(KERNEL)

# Clean up

distclean:
	@cd trees/dtc && git clean -dxf
	@cd trees/u-boot-xlnx/ && git clean -dxf
	@cd trees/linux-xlnx && git clean -dxf
	@rm -rf fsbl dt boot
