#!/bin/sh
set -x

# ARM default toolchain
#TOOLCHAIN=/usr/local/gcc-arm
#TARGET=arm-none-linux-gnueabihf
# Synology 1.3 env
TOOLCHAIN=/usr/local/arm-unknown-linux-gnueabi
TARGET=arm-unknown-linux-gnueabi

# From /env32.mak
TUNE="-mhard-float -mfpu=vfpv3-d16 -march=armv7-a -mtune=cortex-a9" 

# See nodejs/make.py: ccache + parallel make seems to possibly not work
# See https://github.com/nodejs/build/blob/364b8a9d0efe473b22cc04e6b4fa63a4b5e1d67a/ansible/roles/docker/files/cc-selector.sh: seems it is better to set the host, and not the target?
export CC_host="ccache gcc -m32"
export CXX_host="ccache g++ -m32"
export LINK_host="g++ -m32 -Wl,--rpath=/usr/lib32"
#export AR_host="ar-4.9"
export CC="ccache $TOOLCHAIN/bin/$TARGET-gcc $TUNE"
export CXX="ccache $TOOLCHAIN/bin/$TARGET-g++ $TUNE"
#export AR=$TOOLCHAIN/bin/$TARGET-ar

cd node-18.17.1
make distclean
./configure --prefix=/usr/local --dest-cpu arm --dest-os linux --cross-compiling --with-arm-float-abi=hard --with-arm-fpu=vfpv3-d16 # --ninja
# LTO seems to run out of memory
#
#   /usr/local/gcc-arm/bin/arm-none-linux-gnueabihf-gcc -o /source/node-18.17.1/out/Release/obj.target/icudata/gen/icudt73_dat.o /source/node-18.17.1/out/Release/obj/gen/icudt73_dat.c '-DV8_DEPRECATION_WARNINGS' '-DV8_IMMINENT_DEPRECATION_WARNINGS' '-D_GLIBCXX_USE_CXX11_ABI=1' '-DNODE_OPENSSL_CONF_NAME=nodejs_conf' '-DNODE_OPENSSL_HAS_QUIC' '-DICU_NO_USER_DATA_OVERRIDE' '-D__STDC_FORMAT_MACROS' '-DOPENSSL_NO_PINSHARED' '-DOPENSSL_THREADS' '-DU_ATTRIBUTE_DEPRECATED=' '-DU_STATIC_IMPLEMENTATION=1' '-DUCONFIG_NO_SERVICE=1' '-DU_ENABLE_DYLOAD=0' '-DU_HAVE_STD_STRING=1' '-DUCONFIG_NO_BREAK_ITERATION=0' -I../deps/icu-small/source/common  -pthread -Wall -Wextra -Wno-unused-parameter -Wno-deprecated-declarations -Wno-strict-aliasing -O3 -flto=4 -fuse-linker-plugin -ffat-lto-objects -fno-omit-frame-pointer  -MMD -MF /source/node-18.17.1/out/Release/.deps//source/node-18.17.1/out/Release/obj.target/icudata/gen/icudt73_dat.o.d.raw   -c
#arm-none-linux-gnueabihf-gcc: fatal error: Killed signal terminated program cc1
#compilation terminated.
#make[1]: *** [tools/icu/icudata.target.mk:158: /source/node-18.17.1/out/Release/obj.target/icudata/gen/icudt73_dat.o] Error 1
#make: *** [Makefile:134: node] Error 2
#CHROOT@ipq806x-build[/source/node-18.17.1]# ls -al /source/node-18.17.1/out/Release/obj/gen/icudt73_dat.c
#-rw-r--r-- 1 root root 96065384 Aug 27 18:17 /source/node-18.17.1/out/Release/obj/gen/icudt73_dat.c
make -j16
#V=1 ninja -C out/Release -w dupbuild=warn