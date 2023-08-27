#!/bin/sh

# Tool chains
#TOOLCHAIN=arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf
#TOOLCHAIN=gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf
TOOLCHAIN=gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf

docker run --rm -it --name ipq806x-host \
	-v $(pwd)/env:/ds.env \
	-v $(pwd)/source:/ds.env/source \
	-v $(pwd)/toolchains/$TOOLCHAIN:/ds.env/usr/local/gcc-arm \
	-v $(pwd)/ccaches:/ds.env/ccaches \
	ubuntu:latest chroot /ds.env /bin/bash

