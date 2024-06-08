#!/bin/bash -x

set -e

echo "Hallo"

# Assume that the SDCARD is mounted on /dev/sdb

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
sudo mkfs.ext3 /dev/sdb2

# Copy the u-boot loader to partition 3
sudo dd if=./u-boot-socfpga/u-boot-with-spl.sfp of=/dev/sdb3 bs=64k seek=0
