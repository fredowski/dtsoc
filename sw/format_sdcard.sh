#!/bin/bash -x

set -e

if [ $# -ne 1 ]; then
    echo "Format SDCARD on DEVICE"
    echo "Usage $0 DEVICE"
    echo "Example: $0 /dev/sdb"
    exit 0
fi

devname=$1

# Unmount possibly mounted partitions
sudo umount ${devname}1 || true
sudo umount ${devname}2 || true

# Clean SDCARD
sudo dd if=/dev/zero of=${devname} bs=512 count=1

# Partition the SDCARD
# The result of the partioning should be
#Device     Boot Start     End Sectors  Size Id Type
#/dev/sdb1        4096   69631   65536   32M  b W95 FAT32
#/dev/sdb2       69632 1118207 1048576  512M 83 Linux
#/dev/sdb3        2048    4095    2048    1M a2 unknown
sudo fdisk ${devname} <<EOF
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

# Format the windows and the linux partition with label
sudo mkfs.vfat -n DE1SOCF32 ${devname}1
sudo mkfs.ext3 -F -L de1socext3 ${devname}2
sudo sync

