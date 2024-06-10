#!/bin/bash -x

set -e

# Assume that the SDCARD is on /dev/sdb
# Unmount possibly mounted partitions
sudo umount /dev/sdb1 || true
sudo umount /dev/sdb2 || true

# Clean SDCARD
sudo dd if=/dev/zero of=/dev/sdb bs=512 count=1

# Partition the SDCARD
# This result of the partioning should be
#Device     Boot Start     End Sectors  Size Id Type
#/dev/sdb1        4096   69631   65536   32M  b W95 FAT32
#/dev/sdb2       69632 1118207 1048576  512M 83 Linux
#/dev/sdb3        2048    4095    2048    1M a2 unknown
sudo fdisk /dev/sdb <<EOF
n
p
3
2048
4095
t
a2
n
p
1
4096
+32M
t
1
b
n
p
2
69632
+512M
t
2
83
p
w
EOF

# Format the windows and the linux partition
sudo mkfs.vfat /dev/sdb1
sudo mkfs.ext3 -F /dev/sdb2

# Copy the u-boot loader to partition 3
sudo dd if=./u-boot/u-boot-socfpga/u-boot-with-spl.sfp of=/dev/sdb3 bs=64k seek=0

# Mount fat and ext3 filesystems
mkdir -p sdcard/fat32
mkdir -p sdcard/ext3
sudo mount /dev/sdb1 sdcard/fat32
sudo mount /dev/sdb2 sdcard/ext3
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

