# Terasic Altera DE1-SoC Cyclone V Reference Design

This repository contains the build procedures to build a reference based on

  * Intel/Altera Cyclone V FPGA HPS/FPGA system
  * [Terasic DE1-SoC Board](http://de1-soc.terasic.com.tw)
  * U-Boot Boot loader
  * Debian 12.5 Linux

## Terasic DE1-SoC Board

Terasic produces the [Terasic DE1-SoC Board](http://de1-soc.terasic.com.tw) which contains

  * Intel/Altera Cyclone V SoC 5CSEMA5F31C6N FPGA
  * incl. ARM Cortex A9 Dualcores Hard Processor System (HPS)
  * 1GB DDR3 RAM for the Hard Processor System (HPS)
  * Gigabit Ethernet

Intel/Altera sells a different [Intel Cyclone V SoC Development Board](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/cyclone/v-sx.html). 

## Hardware / System Builder Toolchain

Intel/Rocketchip maintains a system builder toolchain example for a Golden Reference Design for the Intel Cyclone V SoC Development Board.

https://github.com/altera-opensource/ghrd-socfpga/tree/master/cv_soc_devkit_ghrd

This toolchain uses

  * Quartus System Builder
  * Quartus Synthesis Software

to build a small HPS/FPGA system. The input of that flow is system builder tcl description with the setup of 

  * HPS Pin Multiplexing, i.e. which HPS Peripheral is muxed to which HPS pin
  * Used internal HPS/FPGA interfaces
  * DDR3 RAM timing setupWe follow that path.

I adapt that setup to fit to the Terasic Board. Sahand Kashani-Akhavan and René Beuchat from EPFL have written an [SoC FPAG Design Guide](https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/SoC-FPGA%20Design%20Guide_EPFL.pdf) with a setup for the DE1-SoC Terasic board. They also made a repository:

 https://github.com/sahandKashani/Altera-FPGA-top-level-files

## Software / U-Boot

The HPS system boots from the SDCARD which is on the board. The quartus system builder toolchain produces some C files which are used during early boot by the U-Boot boot loader:

https://github.com/altera-opensource/u-boot-socfpga

https://github.com/altera-opensource/u-boot-socfpga/blob/socfpga_v2023.10/doc/README.socfpga

https://github.com/altera-opensource/u-boot-socfpga/tree/socfpga_v2023.10/arch/arm/mach-socfpga

You need to install the following packages for U-BOOT

```
sudo apt install gcc-arm-none-eabi bison flex libssl-dev bc
```

u-boot is a submodule of this repository. To fully install it run

```
git submodule init
```

