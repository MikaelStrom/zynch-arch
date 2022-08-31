#!/bin/bash
set -e

VER=$1
BIT=$2
ATF=$3
FSBL=$4
PMUFW=$5
UBOOT=$6
DTB=$7
KERNEL=$8

source scripts/tools.sh $VER

mkdir -p boot

cp -f $BIT boot/zynqmp.bit
cp -f $ATF boot/bl31.elf
cp -f $FSBL boot/fsbl.elf
cp -f $PMUFW boot/pmufw.elf
cp -f $UBOOT boot/u-boot.elf
cp -f $KERNEL boot/Image
cp -f $DTB boot/devicetree.dtb

cat > boot/fit-image.its <<- EOM
/dts-v1/;
/ {
	description = "U-Boot fitImage for aarch64 kernel";
	#address-cells = <1>;
 
	images {
		kernel1 {
			description = "Linux Kernel";
			data = /incbin/("Image.gz");
			type = "kernel";
			arch = "arm64";
			os = "linux";
			compression = "gzip";
			load = <0x00200000>;
			entry = <0x00200000>;
			hash@1 {
				algo = "sha256";
			};
		};
		devicetree.dtb {
			description = "Flattened Device Tree blob";
			data = /incbin/("devicetree.dtb");
			type = "flat_dt";
			arch = "arm64";
			compression = "none";
			hash@1 {
				algo = "sha256";
			};
		};
	};
	configurations {
		default = "conf-system-top.dtb";
		conf-system-top.dtb {
			description = "1 Linux kernel, FDT blob";
			kernel = "kernel1";
			fdt = "devicetree.dtb";
			hash-1 {
				algo = "sha256";
			};
		};
	};
};
EOM

cd boot
gzip Image
mkimage -f fit-image.its image.ub
cd ..

cat > boot/image.bif <<- EOM
the_ROM_image:
{
	[bootloader, destination_cpu=a53-0] boot/fsbl.elf
	[pmufw_image] boot/pmufw.elf
	[destination_device=pl] boot/zynqmp.bit
	[destination_cpu=a53-0, exception_level=el-3, trustzone] boot/bl31.elf
	[destination_cpu=a53-0, load=0x00100000] boot/devicetree.dtb
	[destination_cpu=a53-0, exception_level=el-2] boot/u-boot.elf
}
EOM

# scripts/tools.sh $VER xsct scripts/build-boot.tcl $HDF
xsct -eval "exec bootgen -arch zynqmp -w on -image boot/image.bif -o boot/boot.bin"
