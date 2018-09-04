#!/bin/bash
cd ..
rm -rf modules
export CONFIG_FILE="msm-perf_defconfig"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-android-"
export TOOL_CHAIN_PATH="${HOME}/mk-mr1/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin"
export CONFIG_ABS_PATH="arch/${ARCH}/configs/${CONFIG_FILE}"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export objdir="${HOME}/los14/kernel/smartisan/obj"
export sourcedir="${HOME}/los14/kernel/smartisan/msm8996"
cd $sourcedir
compile() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j8
  make O=$objdir -j6
}
module(){
  mkdir modules
  find . -name '*.ko' -exec cp -av {} modules/ \;
  # strip modules 
  ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded modules/*
  #mkdir modules/qca_cld
  #mv modules/wlan.ko modules/qca_cld/qca_cld_wlan.ko
}
dtbuild(){
  cd $sourcedir
  ./tools/dtbToolCM -2 -o $objdir/arch/arm64/boot/dt.img -s 4096 -p $objdir/scripts/dtc/ $objdir/arch/arm64/boot/dts/
}
compile 
cd $objdir
module
#dtbuild
#cp $objdir/arch/arm64/boot/zImage $sourcedir/zImage
#cp $objdir/arch/arm64/boot/dt.img.lz4 $sourcedir/dt.img
