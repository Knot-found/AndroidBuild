#!/bin/bash

cd ~/AndroidBuild/M/
#get old device sources
cp -Rvf ~/AndroidBuild/L/device/asus/grouper device/asus/grouper

#apply source patch to Nfc package (sadly we must mess with platform code here)
cd packages/apps/Nfc/
git apply ../../../../packages-apps-Nfc.patch
cd ../../..

#apply source patch to vendor repo
cd vendor
git apply ../../vendor.patch
cd ..

#apply source patch to device repo
cd device/asus/grouper
git apply ~/AndroidBuild/patch/device-asus-grouper.patch
cd ../../..

#get kernel
cd ..
git clone https://android.googlesource.com/kernel/tegra.git
cd tegra
git checkout remotes/origin/android-tegra3-grouper-3.1-lollipop-mr1 -b l-mr1

#apply kernel patch
git apply ../patch/kernel.patch

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
time make -j4 >> log.txt
