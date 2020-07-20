#!/bin/bash

set -o errexit

[[ $# -eq 1 ]] || exit 1

DEVICE=$1

if [[ $DEVICE != X00T ]]; then
    echo invalid device codename
    exit 1
fi

TOP=$(realpath ../)

export KBUILD_BUILD_USER=prabhat774
export KBUILD_BUILD_HOST=linux

PATH="$TOP/tools/build-tools/linux-x86/bin:$PATH"
PATH="$TOP/tools/build-tools/path/linux-x86:$PATH"
PATH="$TOP/tools/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$TOP/tools/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$TOP/tools/clang/host/linux-x86/clang-r353983c/bin:$PATH"
PATH="$TOP/tools/misc/linux-x86/lz4:$PATH"
PATH="$TOP/tools/misc/linux-x86/dtc:$PATH"
PATH="$TOP/tools/misc/linux-x86/libufdt:$PATH"
export LD_LIBRARY_PATH="$TOP/tools/clang/host/linux-x86/clang-r353983c/lib64:$LD_LIBRARY_PATH"

make \
    clean \
    mrproper \
    O=out \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi- \
    ${DEVICE}_defconfig
    
make \
    -j$(nproc --all) \
    O=out \
    ARCH=arm64 \
    SUBARCH=ARM64 \
    CC=clang \
    HOSTCC=clang \
    HOSTCXX=clang++ \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-
    
 

rm -rf "$TOP/Output/$DEVICE-kernel"
mkdir -p "$TOP/Output/$DEVICE-kernel"
cp out/arch/arm64/boot/Image.gz-dtb "$TOP/Output/$DEVICE-kernel"





