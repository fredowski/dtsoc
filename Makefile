# Makefile for qsys based Cyclone V generation
# for Altera DE1 SOC Board


# Build the qsys file from a tcl description
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

# U-Boot bootloader
.PHONY: uboot
uboot:
	python3 ./sw/u-boot/u-boot-socfpga/arch/arm/mach-socfpga/cv_bsp_generator/cv_bsp_generator.py \
	  -i ./hps_isw_handoff/de1_soc_hps_0 \
	  -o ./sw/u-boot/u-boot-socfpga/board/altera/cyclone5-socdk/qts
	cd ./sw/u-boot/u-boot-socfpga; \
	  make socfpga_cyclone5_defconfig; \
	  make -j2

# Create the SDCARD
.PHONY: sdcard
sdcard: ./sw/u-boot/u-boot-socfpga/u-boot-with-spl.sfp
	./sw/u-boot/build_sdcard.sh

clean:
	rm -rf *.qpf output_files
