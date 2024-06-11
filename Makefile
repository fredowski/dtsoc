# Makefile for qsys based Cyclone V generation
# for Altera DE1 SOC Board


# Build the qsys file from a tcl file
# which was saved from the qsys gui
de1_soc.qsys: de1_soc_qsys.tcl
	qsys-script --script=de1_soc_qsys.tcl

.PHONY: qip
qip: de1_soc/synthesis/de1_soc.qip

de1_soc/synthesis/de1_soc.qip: de1_soc.qsys
	qsys-generate de1_soc.qsys --synthesis=VHDL

.PHONY: qpf
qpf: de1_soc_top.qpf

de1_soc_top.qpf: de1_soc/synthesis/de1_soc.qip
	quartus_sh --script=create_quartus.tcl || rm de1_soc_top.qpf

output_files/de1_soc_top.map.summary: de1_soc_top.qpf
	quartus_map de1_soc_top.qpf	|| rm output_files/de1_soc_top.map.summary

output_files/de1_soc_top.merge.summary: output_files/de1_soc_top.map.summary
	quartus_cdb --merge de1_soc_top.qpf	|| rm output_files/de1_soc_top.merge.summary

#.PHONY: compile
compile: output_files/de1_soc_top.merge.summary
	#quartus_map de1_soc_top.qpf
	#quartus_cdb --merge de1_soc_top.qpf
	quartus_sta -t de1_soc/synthesis/submodules/hps_sdram_p0_pin_assignments.tcl de1_soc_top.qpf
	quartus_stp de1_soc_top
	quartus_sh --flow compile de1_soc_top.qpf

# Create the FPGA Raw Binary File .rbf from SRAM Object File .sof format
.PHONY: rbf
rbf: output_files/de1_soc_top.rbf

output_files/de1_soc_top.rbf: output_files/de1_soc_top.sof
	quartus_cpf -c output_files/de1_soc_top.sof output_files/de1_soc_top.rbf

# U-Boot bootloader
.PHONY: u-boot
u-boot: ./sw/u-boot/u-boot-socfpga/u-boot-with-spl.sfp

./sw/u-boot/u-boot-socfpga/u-boot-with-spl.sfp: ./hps_isw_handoff/de1_soc_hps_0/de1_soc_hps_0.hiof
	python3 ./sw/u-boot/u-boot-socfpga/arch/arm/mach-socfpga/cv_bsp_generator/cv_bsp_generator.py \
	  -i ./hps_isw_handoff/de1_soc_hps_0 \
	  -o ./sw/u-boot/u-boot-socfpga/board/altera/cyclone5-socdk/qts
	cd ./sw/u-boot/u-boot-socfpga; \
	  make socfpga_cyclone5_defconfig; \
	  make -j2

# u-boot boot script which will load the FPGA
sw/u-boot/u-boot.scr: sw/u-boot/boot.script
	sw/u-boot/u-boot-socfpga/tools/mkimage -A arm -O linux \
	  -T script -C none -a 0 -e 0 -n doof \
	  -d sw/u-boot/boot.script \
	  sw/u-boot/u-boot.scr


# Linux kernel
.PHONY: kernel
kernel: sw/linux/linux-source-6.1/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb

# Assume that package linux-source-6.1 is installed
sw/linux/linux-source-6.1:
	cd sw/linux; tar -xf /usr/src/linux-source-6.1.tar.xz

sw/linux/linux-source-6.1/arch/arm/boot/zImage: sw/linux/linux-source-6.1
	cd sw/linux/linux-source-6.1; \
	  make socfpga_defconfig; \
	  make zImage;

sw/linux/linux-source-6.1/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb: sw/linux/linux-source-6.1/arch/arm/boot/zImage
	cd sw/linux/linux-source-6.1; \
	  make socfpga_cyclone5_socdk.dtb

# Rootfilesystem
.PHONY: rootfs
rootfs: sw/linux/rootfs.tar.gz

sw/linux/rootfs.tar.gz: sw/linux/build_rootfs.sh
	cd sw/linux; ./build_rootfs.sh

# Create the SDCARD
sdcarddeps=sw/linux/linux-source-6.1/arch/arm/boot/zImage \
  sw/linux/linux-source-6.1/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb \
  sw/linux/rootfs.tar.gz \
  sw/u-boot/u-boot-socfpga/u-boot-with-spl.sfp \
  output_files/de1_soc_top.rbf \
  sw/u-boot/u-boot.scr

.PHONY: sdcard
sdcard: $(sdcarddeps)
	cd sw; ./build_sdcard.sh

cleanhw:
	rm -rf output_files db de1_soc
	rm -rf c5_pin_model_dump.txt de1_soc hps_isw_handoff hps_sdram_*
	rm -rf incremental_db
	rm -rf *.qpf *.qsf *.qws *.sopcinfo *.qsys

cleansw:
	rm -rf sw/linux/linux-source-*
	sudo rm -rf sw/linux/rootfs sw/linux/rootfs.tar.gz
	rm -f sw/u-boot/u-boot.scr
	rm -rf sw/sdcard
	cd sw/u-boot/u-boot-socfpga; make clean

clean:
	make cleanhw
	make cleansw


