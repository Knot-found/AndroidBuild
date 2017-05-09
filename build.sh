#!/bin/bash

cd ~/AndroidBuild/tegra
#build kernel
export CROSS_COMPILE=~/AndroidBuild/M/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
export ARCH=arm
time make tegra3_android_defconfig
time make -j4
cp arch/arm/boot/zImage ~/AndroidBuild/M/device/asus/grouper/kernel
cd ~/AndroidBuild/M

#build Android
source build/envsetup.sh
lunch aosp_grouper-userdebug
time make -j4
