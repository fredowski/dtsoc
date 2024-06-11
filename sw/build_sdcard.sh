#!/bin/bash -x

set -e

# Unmount possibly mounted partitions (mounted by automounter)
if [ -f /dev/disk/by-label/de1socext3 ]; then
    sudo umount /dev/disk/by-label/de1socext3
fi
if [ -f /dev/disk/by-label/DE1SOCF32 ]; then
    sudo umount /dev/disk/by-label/DE1SOCF32
fi

# Assume that the SDCARD was formatted with the correct labels
# and mount via the labels


# Mount fat and ext3 filesystems
mkdir -p sdcard/fat32
mkdir -p sdcard/ext3

if ! mount -l | grep sdcard/fat32; then
    echo "Mounting dos partition"
    sudo mount -L DE1SOCF32 sdcard/fat32
fi

if ! mount -l | grep sdcard/ext3; then
    echo "Mounting ext3 partition"
    sudo mount -L de1socext3 sdcard/ext3
fi

# Figure out if we are on /dev/sdb or /dev/sdc or ...
devname=`mount -l | grep de1socext3 | cut -c 1-8`
# We are on partition 3 - This should be /dev/sdb3
devname=${devname}3

# Copy the u-boot loader to partition 3
sudo dd if=./u-boot/u-boot-socfpga/u-boot-with-spl.sfp of=${devname} bs=64k seek=0

# Copy the root filesystem
sudo tar -C sdcard/ext3 -xzf ./linux/rootfs.tar.gz
# Copy the kernel and the linux kernal device tree blob
sudo cp ./linux/linux-source-6.1/arch/arm/boot/zImage ./sdcard/fat32
sudo cp ./linux/linux-source-6.1/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb ./sdcard/fat32
# Copy the fpga programming file
sudo cp ../output_files/de1_soc_top.rbf sdcard/fat32
# Copy the u-boot boot script which will program the FPGA during u-boot bootloading
sudo cp u-boot/u-boot.scr sdcard/fat32
pushd sdcard/fat32
sudo mkdir extlinux
sudo /bin/bash -c "echo 'LABEL Linux Default' > extlinux/extlinux.conf"
sudo /bin/bash -c "echo '    KERNEL ../zImage' >> extlinux/extlinux.conf"
sudo /bin/bash -c "echo '    FDT ../socfpga_cyclone5_socdk.dtb' >> extlinux/extlinux.conf"
sudo /bin/bash -c "echo '    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8' >> extlinux/extlinux.conf"
popd
sudo sync
sudo umount ./sdcard/fat32
sudo umount ./sdcard/ext3
rm -rf sdcard

