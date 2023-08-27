#!/bin/sh

# Environment
# TODO: fetch the tgz from somewhere
mkdir -p env
tar xvf downloads/ds.ipq806x-1.3.env.tgz -C env
tar xvf downloads/ds.ipq806x-1.3.dev.tgz -C env

# Additional toolchain
mkdir -p toolchains
tar xvf downloads/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz -C toolchains

# Sources
# TODO: Fetch node-18.17.1.tar.gz and extract to source/
# TODO: Split third-party and own sources

# spksrc
# TODO: Configure that somehow using our own toolchain/env setup

