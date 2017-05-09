#!/bin/bash

#get Android M AOSP into folder called M
mkdir patch
cd patch
#curl https://doc-0c-b4-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/tj3no55ud8hno99bv781da60n1dskouu/1477447200000/06886540285603939351/*/0B2MsuxYf5GsyWEFZcHF4MlA2LWc?e=download -o patch.zip &&\
# unzip patch.zip
cd ../
mkdir L
mkdir M
cd M
repo init -u https://android.googlesource.com/platform/manifest -b android-6.0.0_r1
repo sync -j4 > /dev/null
cd ..

#get latest L AOSP into folder called L
cd L
repo init -u https://android.googlesource.com/platform/manifest -b android-5.1.1_r1
repo sync -j4 > /dev/null
cd ..

#get blobs (except widevine)
cd M
wget https://dl.google.com/dl/android/aosp/asus-grouper-lmy47v-f395a331.tgz > /dev/null
wget https://dl.google.com/dl/android/aosp/broadcom-grouper-lmy47v-5671ab27.tgz > /dev/null
wget https://dl.google.com/dl/android/aosp/elan-grouper-lmy47v-6a10e8f3.tgz > /dev/null
wget https://dl.google.com/dl/android/aosp/invensense-grouper-lmy47v-ccd43018.tgz > /dev/null
wget https://dl.google.com/dl/android/aosp/nvidia-grouper-lmy47v-c9005750.tgz > /dev/null
wget https://dl.google.com/dl/android/aosp/nxp-grouper-lmy47v-18820f9b.tgz > /dev/null
#wget https://dl.google.com/dl/android/aosp/widevine-grouper-lmy47v-e570494f.tgz
tar xvfz asus-grouper-lmy47v-f395a331.tgz
tar xvfz broadcom-grouper-lmy47v-5671ab27.tgz
tar xvfz elan-grouper-lmy47v-6a10e8f3.tgz
tar xvfz invensense-grouper-lmy47v-ccd43018.tgz
tar xvfz nvidia-grouper-lmy47v-c9005750.tgz
tar xvfz nxp-grouper-lmy47v-18820f9b.tgz
#tar xvfz widevine-grouper-lmy47v-e570494f.tgz
dd if=extract-asus-grouper.sh bs=14466 skip=1       | tar xvz
dd if=extract-broadcom-grouper.sh bs=14464 skip=1   | tar xvz
dd if=extract-elan-grouper.sh bs=14490 skip=1       | tar xvz
dd if=extract-invensense-grouper.sh bs=14456 skip=1 | tar xvz
dd if=extract-nvidia-grouper.sh bs=14460 skip=1     | tar xvz
dd if=extract-nxp-grouper.sh bs=14452 skip=1        | tar xvz
#dd if=extract-widevine-grouper.sh bs=14446 skip=1   | tar xvz
rm *grouper-lmy47v*.tgz extract-*-grouper.sh

#cool binary patch for GL blobs
echo -n dmitrygr_libldr | dd bs=1 seek=4340 conv=notrunc of=vendor/nvidia/grouper/proprietary/libEGL_tegra.so
echo -n dgv1 | dd bs=1 seek=6758 conv=notrunc of=vendor/nvidia/grouper/proprietary/libEGL_tegra.so
echo -n dmitrygr_libldr | dd bs=1 seek=3811 conv=notrunc of=vendor/nvidia/grouper/proprietary/libGLESv1_CM_tegra.so
echo -n dgv1 | dd bs=1 seek=6447 conv=notrunc of=vendor/nvidia/grouper/proprietary/libGLESv1_CM_tegra.so

#cool binary patch for GPS blob
printf "malloc\0" | dd bs=1 seek=5246 conv=notrunc of=vendor/broadcom/grouper/proprietary/glgps
