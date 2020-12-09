#!/bin/sh

##################
# read -p "输入模拟器的.a文件路径 " vmpath
# read -p "输入真机的.a文件路径 " realpath

# #合成模拟器和真机.a包
# lipo -create "${vmpath}" "${realpath}" -output "/Users/mac/Desktop/mySDK.a"

# open "/Users/mac/Desktop"

#####################

mkdir -p MyFrameworks
cd MyFrameworks
# 创建一个MySDK的文件夹来存放MySDK
mkdir -p ${PRODUCT_NAME}
cd ${PRODUCT_NAME}

cp ${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/lib${PRODUCT_NAME}.a ./
iphoneosFile=${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PRODUCT_NAME}.a
iphonesimulatorFile=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PRODUCT_NAME}.a
if [ -f "$iphoneosFile" ] && [ -f "$iphonesimulatorFile" ]; then
lipo -create "$iphoneosFile" "$iphonesimulatorFile" -output ./lib${PRODUCT_NAME}.a
fi
cp ${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/include/${PRODUCT_NAME}/*.* ./
open ./../../