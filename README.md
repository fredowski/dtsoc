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
sudo apt install gcc-arm-linux-gnueabihf bison flex libssl-dev bc
```

u-boot is a submodule of this repository. To fully install it run

```
git submodule init
```

```
make u-boot
```

will build the u-boot bootloader for the Intel Cyclone board but it works also for the
Terasic DE1-SoC.

## Linux Kernel


Install the kernel sources on the build machine. For debian 12.5 this 6.1. An
alternative is the repo https://github.com/altera-opensource/linux-socfpga

```
sudo apt install linux-source-6.1
```

```
make kernel
```

will build
  * linux kernel 6.1.90 which belongs to debian 12.5 for armhf
  * linux device tree

## Linux Rootfilesystem

We use the debian bookworm rootfs. To build the rootfs we need the
following tools

```
sudo apt install debootstrap qemu-user-static
```

```
make rootfs
```

builds the Debian bookworm root filesystem

## SDCARD

Attach a Micro SDCARD to your host computer. The SDCARD will contain the
  * u-boot boot loader
  * linux kernel
  * linux root file system
Use

```
make sdcard
```

to format and configure the sdcard.

## Test the system

### MSEL switches
Switch the MSEL switches on the backside of the board to MSEL[0..4]="01010".

### Wiring
Add the
  * Power Supply
  * USB Cable to the "UART to USB" port in the upper right corner
  * Insert the SDCARD

### Terminal
Run

```
gtkterm --port=/dev/ttyUSB0
```
and switch on the board. You should see the following boot log:

```
U-Boot SPL 2023.10-31848-g0b3e82ca6e-dirty (Jun 08 2024 - 20:39:14 +0200)
Trying to boot from MMC1


U-Boot 2023.10-31848-g0b3e82ca6e-dirty (Jun 08 2024 - 20:39:14 +0200)

CPU:   Altera SoCFPGA Platform
FPGA:  Altera Cyclone V, SE/A5 or SX/C5 or ST/D5, version 0x0
BOOT:  SD/MMC Internal Transceiver (3.0V)
DRAM:  1 GiB
Core:  32 devices, 18 uclasses, devicetree: separate
MMC:   dwmmc0@ff704000: 0
Loading Environment from MMC... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial
Model: Altera SOCFPGA Cyclone V SoC Development Kit
Net:   
Warning: ethernet@ff702000 (eth0) using random MAC address - fa:f5:c3:55:25:f5
eth0: ethernet@ff702000
Hit any key to stop autoboot:  2  1  0 
Failed to load 'u-boot.scr'
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found /extlinux/extlinux.conf
Retrieving file: /extlinux/extlinux.conf
1:	Linux Default
Retrieving file: /extlinux/../zImage
append: root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8
Retrieving file: /extlinux/../socfpga_cyclone5_socdk.dtb
Kernel image @ 0x1000000 [ 0x000000 - 0x58a108 ]
## Flattened Device Tree blob at 02000000
   Booting using the fdt blob at 0x2000000
Working FDT set to 2000000
   Loading Device Tree to 09ff8000, end 09ffff4b ... OK
Working FDT set to 9ff8000

Starting kernel ...

Deasserting all peripheral resets
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 6.1.90 (caeuser@vcae) (arm-linux-gnueabihf-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #1 SMP Sun Jun  9 20:11:53 CEST 2024
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: Altera SOCFPGA Cyclone V SoC Development Kit
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x000000002fffffff]
[    0.000000]   HighMem  [mem 0x0000000030000000-0x000000003fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] percpu: Embedded 15 pages/cpu s29780 r8192 d23468 u61440
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 260608
[    0.000000] Kernel command line: root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8
[    0.000000] Unknown kernel command line parameters "earlyprintk", will be passed to user space.
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.000000] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
[    0.000000] Memory: 1025068K/1048576K available (9216K kernel code, 812K rwdata, 2004K rodata, 1024K init, 166K bss, 23508K reserved, 0K cma-reserved, 262144K highmem)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] ftrace: allocating 30447 entries in 90 pages
[    0.000000] ftrace: allocated 90 pages with 4 groups
[    0.000000] trace event string verifier disabled
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: 	RCU event tracing is enabled.
[    0.000000] 	Rude variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] L2C-310 erratum 769419 enabled
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 ID prefetch enabled, offset 8 lines
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 8 ways, 512 kB
[    0.000000] L2C-310: CACHE_ID 0x410030c9, AUX_CTRL 0x76460001
[    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on contention.
[    0.000000] clocksource: timer1: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
[    0.000000] sched_clock: 32 bits at 100MHz, resolution 10ns, wraps every 21474836475ns
[    0.000013] Switching to timer-based delay loop, resolution 10ns
[    0.000321] Console: colour dummy device 80x30
[    0.000359] Calibrating delay loop (skipped), value calculated using timer frequency.. 200.00 BogoMIPS (lpj=1000000)
[    0.000372] CPU: Testing write buffer coherency: ok
[    0.000406] CPU0: Spectre v2: using BPIALL workaround
[    0.000413] pid_max: default: 32768 minimum: 301
[    0.000566] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.000579] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.001361] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.002201] cblist_init_generic: Setting adjustable number of callback queues.
[    0.002209] cblist_init_generic: Setting shift to 1 and lim to 1.
[    0.002328] Setting up static identity map for 0x100000 - 0x100060
[    0.002475] rcu: Hierarchical SRCU implementation.
[    0.002481] rcu: 	Max phase no-delay instances is 1000.
[    0.002890] smp: Bringing up secondary CPUs ...
[    0.003596] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.003614] CPU1: Spectre v2: using BPIALL workaround
[    0.003725] smp: Brought up 1 node, 2 CPUs
[    0.003735] SMP: Total of 2 processors activated (400.00 BogoMIPS).
[    0.003744] CPU: All CPU(s) started in SVC mode.
[    0.004334] devtmpfs: initialized
[    0.007984] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9 rev 4
[    0.008170] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.008189] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
[    0.009264] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.010072] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.010956] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
[    0.010967] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.035134] SCSI subsystem initialized
[    0.035296] usbcore: registered new interface driver usbfs
[    0.035333] usbcore: registered new interface driver hub
[    0.035370] usbcore: registered new device driver usb
[    0.035509] usb_phy_generic soc:usbphy: supply vcc not found, using dummy regulator
[    0.035623] usb_phy_generic soc:usbphy: dummy supplies not allowed for exclusive requests
[    0.035929] pps_core: LinuxPPS API ver. 1 registered
[    0.035935] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.035951] PTP clock support registered
[    0.036071] FPGA manager framework
[    0.036680] vgaarb: loaded
[    0.037235] clocksource: Switched to clocksource timer1
[    0.044952] NET: Registered PF_INET protocol family
[    0.045181] IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.046814] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.046845] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.046860] TCP established hash table entries: 8192 (order: 3, 32768 bytes, linear)
[    0.046926] TCP bind hash table entries: 8192 (order: 5, 131072 bytes, linear)
[    0.047126] TCP: Hash tables configured (established 8192 bind 8192)
[    0.047309] UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
[    0.047361] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, linear)
[    0.047552] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.058302] RPC: Registered named UNIX socket transport module.
[    0.058313] RPC: Registered udp transport module.
[    0.058316] RPC: Registered tcp transport module.
[    0.058320] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.058333] PCI: CLS 0 bytes, default 64
[    0.059075] hw perfevents: enabled with armv7_cortex_a9 PMU driver, 7 counters available
[    0.060246] workingset: timestamp_bits=30 max_order=18 bucket_order=0
[    0.065226] NFS: Registering the id_resolver key type
[    0.065288] Key type id_resolver registered
[    0.065294] Key type id_legacy registered
[    0.066012] jffs2: version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[    0.066622] bounce: pool size: 64 pages
[    0.066702] io scheduler mq-deadline registered
[    0.066709] io scheduler kyber registered
[    0.071859] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.072864] printk: console [ttyS0] disabled
[    0.072927] ffc02000.serial0: ttyS0 at MMIO 0xffc02000 (irq = 30, base_baud = 6250000) is a 16550A
[    0.754090] printk: console [ttyS0] enabled
[    0.759112] ffc03000.serial1: ttyS1 at MMIO 0xffc03000 (irq = 31, base_baud = 6250000) is a 16550A
[    0.769577] brd: module loaded
[    0.777733] loop: module loaded
[    0.781977] spi-nor spi0.0: unrecognized JEDEC id bytes: ff ff ff ff ff ff
[    0.791203] CAN device driver interface
[    0.795613] c_can_platform ffc00000.can: c_can_platform device registered (regs=(ptrval), irq=34)
[    0.804824] socfpga-dwmac ff702000.ethernet: IRQ eth_wake_irq not found
[    0.811437] socfpga-dwmac ff702000.ethernet: IRQ eth_lpi not found
[    0.817720] socfpga-dwmac ff702000.ethernet: PTP uses main clock
[    0.823941] socfpga-dwmac ff702000.ethernet: User ID: 0x10, Synopsys ID: 0x37
[    0.831077] socfpga-dwmac ff702000.ethernet: 	DWMAC1000
[    0.836284] socfpga-dwmac ff702000.ethernet: DMA HW capability register supported
[    0.843744] socfpga-dwmac ff702000.ethernet: RX Checksum Offload Engine supported
[    0.851203] socfpga-dwmac ff702000.ethernet: COE Type 2
[    0.856409] socfpga-dwmac ff702000.ethernet: TX Checksum insertion supported
[    0.863435] socfpga-dwmac ff702000.ethernet: Enhanced/Alternate descriptors
[    0.870375] socfpga-dwmac ff702000.ethernet: Enabled extended descriptors
[    0.877135] socfpga-dwmac ff702000.ethernet: Ring mode enabled
[    0.882956] socfpga-dwmac ff702000.ethernet: Enable RX Mitigation via HW Watchdog Timer
[    0.899512] Micrel KSZ9021 Gigabit PHY stmmac-0:01: attached PHY driver (mii_bus:phy_addr=stmmac-0:01, irq=POLL)
[    0.911173] dwc2 ffb40000.usb: supply vusb_d not found, using dummy regulator
[    0.918427] dwc2 ffb40000.usb: supply vusb_a not found, using dummy regulator
[    0.925810] dwc2 ffb40000.usb: EPs: 16, dedicated fifos, 8064 entries in SPRAM
[    0.933318] dwc2 ffb40000.usb: DWC OTG Controller
[    0.938052] dwc2 ffb40000.usb: new USB bus registered, assigned bus number 1
[    0.945095] dwc2 ffb40000.usb: irq 36, io mem 0xffb40000
[    0.951082] hub 1-0:1.0: USB hub found
[    0.954854] hub 1-0:1.0: 1 port detected
[    0.959559] usbcore: registered new interface driver usb-storage
[    0.965751] i2c_dev: i2c /dev entries driver
[    0.970968] Synopsys Designware Multimedia Card Interface Driver
[    0.977329] ledtrig-cpu: registered to indicate activity on CPUs
[    0.983442] usbcore: registered new interface driver usbhid
[    0.989017] usbhid: USB HID core driver
[    0.994071] NET: Registered PF_INET6 protocol family
[    1.000141] Segment Routing with IPv6
[    1.003845] In-situ OAM (IOAM) with IPv6
[    1.007847] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    1.014287] NET: Registered PF_PACKET protocol family
[    1.019362] NET: Registered PF_KEY protocol family
[    1.024137] can: controller area network core
[    1.028540] NET: Registered PF_CAN protocol family
[    1.033317] can: raw protocol
[    1.036276] can: broadcast manager protocol
[    1.040465] can: netlink gateway - max_hops=1
[    1.044861] 8021q: 802.1Q VLAN Support v1.8
[    1.049086] Key type dns_resolver registered
[    1.053412] ThumbEE CPU extension supported.
[    1.057696] Registering SWP/SWPB emulation handler
[    1.066359] at24 0-0051: supply vcc not found, using dummy regulator
[    1.101126] rtc-ds1307: probe of 0-0068 failed with error -121
[    1.111134] dma-pl330 ffe01000.pdma: Loaded driver for PL330 DMAC-341330
[    1.117860] dma-pl330 ffe01000.pdma: 	DBUFF-512x8bytes Num_Chans-8 Num_Peri-32 Num_Events-8
[    1.126888] dw_mmc ff704000.dwmmc0: IDMAC supports 32-bit address mode.
[    1.133550] dw_mmc ff704000.dwmmc0: Using internal DMA controller.
[    1.139733] dw_mmc ff704000.dwmmc0: Version ID is 240a
[    1.144896] dw_mmc ff704000.dwmmc0: DW MMC controller at irq 51,32 bit host data width,1024 deep fifo
[    1.154376] dw_mmc ff704000.dwmmc0: Got CD GPIO
[    1.158968] mmc_host mmc0: card is polling.
[    1.163710] clk: Disabling unused clocks
[    1.167863] dw-apb-uart ffc02000.serial0: forbid DMA for kernel console
[    1.175777] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 400000Hz, actual 396825HZ div = 63)
[    1.197467] Waiting for root device /dev/mmcblk0p2...
[    1.236113] mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 50000000Hz, actual 50000000HZ div = 0)
[    1.245960] mmc0: new high speed SDHC card at address 1234
[    1.252033] mmcblk0: mmc0:1234 SA04G 3.68 GiB 
[    1.259026]  mmcblk0: p1 p2 p3
[    1.268524] EXT4-fs (mmcblk0p2): mounting ext3 file system using the ext4 subsystem
[    1.307257] usb 1-1: new high-speed USB device number 2 using dwc2
[    1.567918] hub 1-1:1.0: USB hub found
[    1.571726] hub 1-1:1.0: 2 ports detected
[    5.730297] EXT4-fs (mmcblk0p2): recovery complete
[    5.739348] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Quota mode: disabled.
[    5.748251] VFS: Mounted root (ext3 filesystem) on device 179:2.
[    5.754962] devtmpfs: mounted
[    5.760597] Freeing unused kernel image (initmem) memory: 1024K
[    5.766817] Run /sbin/init as init process
[    6.323911] systemd[1]: System time before build time, advancing clock.
[    6.360621] systemd[1]: systemd 252.22-1~deb12u1 running in system mode (+PAM +AUDIT +SELINUX +APPARMOR +IMA +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK -XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
[    6.395851] systemd[1]: Detected architecture arm.

Welcome to [1mDebian GNU/Linux 12 (bookworm)[0m!


[    6.432399] systemd[1]: Hostname set to <vcae>.
[    7.376632] systemd[1]: Queued start job for default target graphical.target.
[    7.388633] systemd[1]: Created slice system-getty.slice - Slice /system/getty.
[[0;32m  OK  [0m] Created slice [0;1;39msystem-getty.slice[0m - Slice /system/getty.

[    7.428794] systemd[1]: Created slice system-modprobe.slice - Slice /system/modprobe.
[[0;32m  OK  [0m] Created slice [0;1;39msystem-modpr…lice[0m - Slice /system/modprobe.

[    7.468768] systemd[1]: Created slice system-serial\x2dgetty.slice - Slice /system/serial-getty.
[[0;32m  OK  [0m] Created slice [0;1;39msystem-seria…[0m - Slice /system/serial-getty.

[    7.517790] systemd[1]: Started systemd-ask-password-console.path - Dispatch Password Requests to Console Directory Watch.
[[0;32m  OK  [0m] Started [0;1;39msystemd-ask-passwo…quests to Console Directory Watch.

[    7.567700] systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
[[0;32m  OK  [0m] Started [0;1;39msystemd-ask-passwo… Requests to Wall Directory Watch.

[    7.617718] systemd[1]: proc-sys-fs-binfmt_misc.automount - Arbitrary Executable File Formats File System Automount Point was skipped because of an unmet condition check (ConditionPathExists=/proc/sys/fs/binfmt_misc).
[    7.637158] systemd[1]: Expecting device dev-ttyS0.device - /dev/ttyS0...
         Expecting device [0;1;39mdev-ttyS0.device[0m - /dev/ttyS0...

[    7.667467] systemd[1]: Reached target cryptsetup.target - Local Encrypted Volumes.
[[0;32m  OK  [0m] Reached target [0;1;39mcryptsetup.…get[0m - Local Encrypted Volumes.

[    7.707632] systemd[1]: Reached target integritysetup.target - Local Integrity Protected Volumes.
[[0;32m  OK  [0m] Reached target [0;1;39mintegrityse…Local Integrity Protected Volumes.

[    7.747587] systemd[1]: Reached target paths.target - Path Units.
[[0;32m  OK  [0m] Reached target [0;1;39mpaths.target[0m - Path Units.

[    7.777594] systemd[1]: Reached target remote-fs.target - Remote File Systems.
[[0;32m  OK  [0m] Reached target [0;1;39mremote-fs.target[0m - Remote File Systems.

[    7.817469] systemd[1]: Reached target slices.target - Slice Units.
[[0;32m  OK  [0m] Reached target [0;1;39mslices.target[0m - Slice Units.

[    7.857613] systemd[1]: Reached target swap.target - Swaps.
[[0;32m  OK  [0m] Reached target [0;1;39mswap.target[0m - Swaps.

[    7.897544] systemd[1]: Reached target veritysetup.target - Local Verity Protected Volumes.
[[0;32m  OK  [0m] Reached target [0;1;39mveritysetup… - Local Verity Protected Volumes.

[    7.937843] systemd[1]: Listening on systemd-initctl.socket - initctl Compatibility Named Pipe.
[[0;32m  OK  [0m] Listening on [0;1;39msystemd-initc… initctl Compatibility Named Pipe.

[    7.997426] systemd[1]: systemd-journald-audit.socket - Journal Audit Socket was skipped because of an unmet condition check (ConditionSecurity=audit).
[    8.011987] systemd[1]: Listening on systemd-journald-dev-log.socket - Journal Socket (/dev/log).
[[0;32m  OK  [0m] Listening on [0;1;39msystemd-journ…t[0m - Journal Socket (/dev/log).

[    8.058239] systemd[1]: Listening on systemd-journald.socket - Journal Socket.
[[0;32m  OK  [0m] Listening on [0;1;39msystemd-journald.socket[0m - Journal Socket.

[    8.098415] systemd[1]: Listening on systemd-udevd-control.socket - udev Control Socket.
[[0;32m  OK  [0m] Listening on [0;1;39msystemd-udevd….socket[0m - udev Control Socket.

[    8.138126] systemd[1]: Listening on systemd-udevd-kernel.socket - udev Kernel Socket.
[[0;32m  OK  [0m] Listening on [0;1;39msystemd-udevd…l.socket[0m - udev Kernel Socket.

[    8.177528] systemd[1]: Reached target sockets.target - Socket Units.
[[0;32m  OK  [0m] Reached target [0;1;39msockets.target[0m - Socket Units.

[    8.217957] systemd[1]: dev-hugepages.mount - Huge Pages File System was skipped because of an unmet condition check (ConditionPathExists=/sys/kernel/mm/hugepages).
[    8.233187] systemd[1]: dev-mqueue.mount - POSIX Message Queue File System was skipped because of an unmet condition check (ConditionPathExists=/proc/sys/fs/mqueue).
[    8.297784] systemd[1]: Mounting sys-kernel-debug.mount - Kernel Debug File System...
         Mounting [0;1;39msys-kernel-debug.…[0m - Kernel Debug File System...

[    8.341354] systemd[1]: Mounting sys-kernel-tracing.mount - Kernel Trace File System...
         Mounting [0;1;39msys-kernel-tracin…[0m - Kernel Trace File System...

[    8.377899] systemd[1]: kmod-static-nodes.service - Create List of Static Device Nodes was skipped because of an unmet condition check (ConditionFileNotEmpty=/lib/modules/6.1.90/modules.devname).
[    8.400017] systemd[1]: Starting modprobe@configfs.service - Load Kernel Module configfs...
         Starting [0;1;39mmodprobe@configfs…m - Load Kernel Module configfs...

[    8.441753] systemd[1]: Starting modprobe@dm_mod.service - Load Kernel Module dm_mod...
         Starting [0;1;39mmodprobe@dm_mod.s…[0m - Load Kernel Module dm_mod...

[    8.481904] systemd[1]: Starting modprobe@efi_pstore.service - Load Kernel Module efi_pstore...
         Starting [0;1;39mmodprobe@efi_psto…- Load Kernel Module efi_pstore...

[    8.567968] systemd[1]: Starting modprobe@fuse.service - Load Kernel Module fuse...
         Starting [0;1;39mmodprobe@fuse.ser…e[0m - Load Kernel Module fuse...

[    8.611970] systemd[1]: Starting modprobe@loop.service - Load Kernel Module loop...
         Starting [0;1;39mmodprobe@loop.ser…e[0m - Load Kernel Module loop...

[    8.648654] systemd[1]: systemd-journald.service: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    8.661534] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    8.707998] systemd[1]: Starting systemd-journald.service - Journal Service...
         Starting [0;1;39msystemd-journald.service[0m - Journal Service...

[    8.757935] systemd[1]: Starting systemd-modules-load.service - Load Kernel Modules...
         Starting [0;1;39msystemd-modules-l…rvice[0m - Load Kernel Modules...

[    8.781826] systemd[1]: Starting systemd-remount-fs.service - Remount Root and Kernel File Systems...
         Starting [0;1;39msystemd-remount-f…nt Root and Kernel File Systems...

[    8.831526] systemd[1]: Starting systemd-udev-trigger.service - Coldplug All udev Devices...
         Starting [0;1;39msystemd-udev-trig…[0m - Coldplug All udev Devices...

[    8.895190] systemd[1]: Mounted sys-kernel-debug.mount - Kernel Debug File System.
[[0;32m  OK  [0m] Mounted [0;1;39msys-kernel-debug.m…nt[0m - Kernel Debug File System.

[    8.917530] systemd[1]: Started systemd-journald.service - Journal Service.
[[0;32m  OK  [0m] Started [0;1;39msystemd-journald.service[0m - Journal Service.

[[0;32m  OK  [0m] Mounted [0;1;39msys-kernel-tracing…nt[0m - Kernel Trace File System.

[[0;32m  OK  [0m] Finished [0;1;39mmodprobe@configfs…[0m - Load Kernel Module configfs.

[[0;32m  OK  [0m] Finished [0;1;39mmodprobe@dm_mod.s…e[0m - Load Kernel Module dm_mod.

[[0;32m  OK  [0m] Finished [0;1;39mmodprobe@efi_psto…m - Load Kernel Module efi_pstore.

[[0;32m  OK  [0m] Finished [0;1;39mmodprobe@fuse.service[0m - Load Kernel Module fuse.

[[0;32m  OK  [0m] Finished [0;1;39mmodprobe@loop.service[0m - Load Kernel Module loop.

[[0;32m  OK  [0m] Finished [0;1;39msystemd-modules-l…service[0m - Load Kernel Modules.

[[0;32m  OK  [0m] Finished [0;1;39msystemd-remount-f…ount Root and Kernel File Systems.

         Starting [0;1;39msystemd-journal-f…h Journal to Persistent Storage...

[    9.327959] systemd-journald[74]: Received client request to flush runtime journal.
         Starting [0;1;39msystemd-random-se…ice[0m - Load/Save Random Seed...

[    9.343881] systemd-journald[74]: File /var/log/journal/86274804149f420191be9344ebb52813/system.journal corrupted or uncleanly shut down, renaming and replacing.
         Starting [0;1;39msystemd-sysctl.se…ce[0m - Apply Kernel Variables...

         Starting [0;1;39msystemd-sysusers.…rvice[0m - Create System Users...

[[0;32m  OK  [0m] Finished [0;1;39msystemd-udev-trig…e[0m - Coldplug All udev Devices.

         Starting [0;1;39mifupdown-pre.serv…ynchronize boot up for ifupdown...

[[0m[0;31m*     [0m] (1 of 6) Job systemd-sysctl.service/start running (4s / 1min 31s)

M
[K[[0;1;31m*[0m[0;31m*    [0m] (1 of 6) Job systemd-sysctl.service/start running (5s / 1min 31s)

M
[K[[0;31m*[0;1;31m*[0m[0;31m*   [0m] (1 of 6) Job systemd-sysctl.service/start running (5s / 1min 31s)

M
[K[ [0;31m*[0;1;31m*[0m[0;31m*  [0m] (2 of 6) Job systemd-journal-flush.…vice/start running (6s / 1min 31s)

M
[K[  [0;31m*[0;1;31m*[0m[0;31m* [0m] (2 of 6) Job systemd-journal-flush.…vice/start running (6s / 1min 31s)

M
[K[[0;32m  OK  [0m] Finished [0;1;39msystemd-sysctl.service[0m - Apply Kernel Variables.

[K[[0;32m  OK  [0m] Finished [0;1;39msystemd-sysusers.service[0m - Create System Users.

[[0;32m  OK  [0m] Finished [0;1;39mifupdown-pre.serv… synchronize boot up for ifupdown.

         Starting [0;1;39msystemd-tmpfiles-…ate Static Device Nodes in /dev...

[   16.877233] random: crng init done
[   [0;31m*[0;1;31m*[0m[0;31m*[0m] (2 of 4) Job systemd-tmpfiles-setup…ice/start running (10s / no limit)

M
[K[    [0;31m*[0;1;31m*[0m] (3 of 4) Job systemd-random-seed.se…ice/start running (10s / 10min 1s)

M
[K[     [0;31m*[0m] (3 of 4) Job systemd-random-seed.se…ice/start running (11s / 10min 1s)

M
[K[    [0;31m*[0;1;31m*[0m] (3 of 4) Job systemd-random-seed.se…ice/start running (12s / 10min 1s)

M
[K[   [0;31m*[0;1;31m*[0m[0;31m*[0m] (4 of 4) Job dev-ttyS0.device/start running (12s / 1min 30s)

M
[K[  [0;31m*[0;1;31m*[0m[0;31m* [0m] (4 of 4) Job dev-ttyS0.device/start running (13s / 1min 30s)

M
[K[ [0;31m*[0;1;31m*[0m[0;31m*  [0m] (4 of 4) Job dev-ttyS0.device/start running (13s / 1min 30s)

M
[K[[0;31m*[0;1;31m*[0m[0;31m*   [0m] (1 of 4) Job systemd-journal-flush.…ice/start running (14s / 1min 31s)

M
[K[[0;1;31m*[0m[0;31m*    [0m] (1 of 4) Job systemd-journal-flush.…ice/start running (15s / 1min 31s)

M
[K[[0m[0;31m*     [0m] (1 of 4) Job systemd-journal-flush.…ice/start running (15s / 1min 31s)

M
[K[[0;32m  OK  [0m] Finished [0;1;39msystemd-journal-f…ush Journal to Persistent Storage.

[K[[0;32m  OK  [0m] Finished [0;1;39msystemd-random-se…rvice[0m - Load/Save Random Seed.

[[0;32m  OK  [0m] Finished [0;1;39msystemd-tmpfiles-…reate Static Device Nodes in /dev.

[[0;32m  OK  [0m] Reached target [0;1;39mlocal-fs-pr…reparation for Local File Systems.

[[0;32m  OK  [0m] Reached target [0;1;39mlocal-fs.target[0m - Local File Systems.

         Starting [0;1;39mnetworking.service[0m - Raise network interfaces...

         Starting [0;1;39msystemd-tmpfiles-… Volatile Files and Directories...

         Starting [0;1;39msystemd-udevd.ser…ger for Device Events and Files...

[[0;32m  OK  [0m] Finished [0;1;39msystemd-tmpfiles-…te Volatile Files and Directories.

         Starting [0;1;39msystemd-update-ut…rd System Boot/Shutdown in UTMP...

[[0;32m  OK  [0m] Started [0;1;39msystemd-udevd.serv…nager for Device Events and Files.

[[0;32m  OK  [0m] Finished [0;1;39msystemd-update-ut…cord System Boot/Shutdown in UTMP.

[   23.941511] socfpga-dwmac ff702000.ethernet end0: renamed from eth0
[[0;32m  OK  [0m] Finished [0;1;39mnetworking.service[0m - Raise network interfaces.

[[0;32m  OK  [0m] Found device [0;1;39mdev-ttyS0.device[0m - /dev/ttyS0.

[[0;32m  OK  [0m] Reached target [0;1;39mnetwork.target[0m - Network.

[[0;32m  OK  [0m] Reached target [0;1;39msysinit.target[0m - System Initialization.

[[0;32m  OK  [0m] Started [0;1;39mapt-daily.timer[0m - Daily apt download activities.

[[0;32m  OK  [0m] Started [0;1;39mapt-daily-upgrade.… apt upgrade and clean activities.

[[0;32m  OK  [0m] Started [0;1;39mdpkg-db-backup.tim… Daily dpkg database backup timer.

[[0;32m  OK  [0m] Started [0;1;39me2scrub_all.timer…etadata Check for All Filesystems.

[[0;32m  OK  [0m] Started [0;1;39mfstrim.timer[0m - Discard unused blocks once a week.

[[0;32m  OK  [0m] Started [0;1;39mlogrotate.timer[0m - Daily rotation of log files.

[[0;32m  OK  [0m] Started [0;1;39msystemd-tmpfiles-c… Cleanup of Temporary Directories.

[[0;32m  OK  [0m] Reached target [0;1;39mtimers.target[0m - Timer Units.

[[0;32m  OK  [0m] Reached target [0;1;39musb-gadget.…m - Hardware activated USB gadget.

[[0;32m  OK  [0m] Reached target [0;1;39mbasic.target[0m - Basic System.

[[0;32m  OK  [0m] Started [0;1;39mcron.service[0m -…kground program processing daemon.

         Starting [0;1;39me2scrub_reap.serv…e ext4 Metadata Check Snapshots...

         Starting [0;1;39mgetty-static.serv…us and logind are not available...

         Starting [0;1;39msystemd-user-sess…vice[0m - Permit User Sessions...

[[0;32m  OK  [0m] Finished [0;1;39msystemd-user-sess…ervice[0m - Permit User Sessions.

[[0;32m  OK  [0m] Finished [0;1;39me2scrub_reap.serv…ine ext4 Metadata Check Snapshots.

[[0;32m  OK  [0m] Finished [0;1;39mgetty-static.serv…dbus and logind are not available.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty1.service[0m - Getty on tty1.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty2.service[0m - Getty on tty2.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty3.service[0m - Getty on tty3.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty4.service[0m - Getty on tty4.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty5.service[0m - Getty on tty5.

[[0;32m  OK  [0m] Started [0;1;39mgetty@tty6.service[0m - Getty on tty6.

[[0;32m  OK  [0m] Started [0;1;39mserial-getty@ttyS0…rvice[0m - Serial Getty on ttyS0.

[[0;32m  OK  [0m] Reached target [0;1;39mgetty.target[0m - Login Prompts.

[[0;32m  OK  [0m] Reached target [0;1;39mmulti-user.target[0m - Multi-User System.

[[0;32m  OK  [0m] Reached target [0;1;39mgraphical.target[0m - Graphical Interface.

         Starting [0;1;39msystemd-update-ut… Record Runlevel Change in UTMP...

[[0;32m  OK  [0m] Finished [0;1;39msystemd-update-ut… - Record Runlevel Change in UTMP.



Debian GNU/Linux 12 vcae ttyS0

vcae login: 
```

### Login and test

Login as "caeuser" with password "caeuser"

Run

```
sudo gpioset 1 24=1
```

and the green "USER LED" in the lower right corner of the board should switch on.
