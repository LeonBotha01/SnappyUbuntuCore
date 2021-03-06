# SnappyUbuntuCore
Develop Roseapple Pi to Snappy 16 [Snappy Ubuntu Core](http://developer.ubuntu.com/snappy/) 

## Structure
builder: build Snappy via makefiles, and that includes Gadget snap and Kernel snap.  
prebuild: prebuild iamge for test purpose.

## Requirements
Make sure your build environment is based on `Ubuntu 16.04` or later. Then, you need to install snappy tools, for creating image.

To build all parts, a couple of dependencies are required. On Ubuntu you can install all build dependencies with the following command.

```bash
sudo apt-get update
sudo apt-get install -y build-essential u-boot-tools lzop debootstrap gcc-4.8-arm-linux-gnueabihf device-tree-compiler
sudo apt-get install -y ubuntu-device-flash ubuntu-snappy snapcraft
```

### Limitation
xapp-le kernel can't be cross compiled by gcc 5+ arm-linux-gnueabihf, so you have to make soft link to gcc 4.8 related toolchain.  

For ubuntu-device-flash, we still use the binary provided by mvo's [u-d-f](https://people.canonical.com/~mvo/all-snaps/ubuntu-device-flash) to build Ubuntu Core 16 image temporarily. I also put it as backup in folder builder/tools

Generate ssh key-pair if you did not have one

```bash
ssh-keygen -t rsa
```

## Quick Build
A `Makefile` is provided to build Snappy, Gadget snap, U-Boot, Kernel snap from source. The sources will be cloned into local folders if not there already.

To build it all, just run `make snappy`. This will produce a Snappy image, a gadget snap `roseapple-pi_x.y_all.snap` and a kernel snap `roseapple-pi-kernel_x.y.z.snap` for device part, which can be used to build your own Snappy image.

### Custom Image
If you want to build the speical version with including the snap you'd like to install from ubuntu store, you can modify the snappy.mk to reach it. For example:  

```bash
sudo ubuntu-device-flash core 16 \
	--channel $CHANNEL \
	--size 4 \
	--enable-ssh \
	--gadget roseapple-pi_x.y_all.snap \
	--kernel roseapple-pi-kernel_x.y.z.snap \
	--os ubuntu-core \
	--install docker \
	-o snappy-16.img
```

### Build U-boot

```bash
make u-boot
```

### Build Gadget snap

```bash
make gadget
```

### Build Kernel snap

```bash
make kernelsnap
```

### Rebuild a snappy
To rebuild the snappy or other parts, just type `make clean` or `make clean-{prefix}`. The prefix will be u-boot, gadget, kernelsnap, etc. 

## Flash to SD card
Before dd, we suggest the SD card storage should be umounted to safely clean up.

```bash
xzcat ${image} | pv | sudo dd of=/dev/${device} bs=32M ; sync
```
