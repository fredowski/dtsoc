#!/bin/bash -x

set -e

# Install new fake root armhf filesystem from debian packages
sudo rm -rf rootfs
mkdir rootfs
sudo fakeroot debootstrap --foreign --arch=armhf bookworm ./rootfs
sudo chroot ./rootfs /debootstrap/debootstrap --second-stage

# Add some packages
sudo chroot ./rootfs apt install -y sudo gpiod memtool

# Create user caeuser
sudo chroot ./rootfs useradd -m caeuser
sudo chroot ./rootfs adduser caeuser sudo
sudo chroot ./rootfs /bin/bash -c "echo caeuser:caeuser | chpasswd"

# Tar the rootfs
sudo tar -C ./rootfs -czpf ./rootfs.tar.gz .
