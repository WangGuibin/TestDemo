# 静态库合成脚本

1. 先创建`.a`静态库,加入代码
2. 分别用模拟器和真机编译代码
3. 新建`run script` 加入执行脚本的代码
4. 编译即可弹出合成好的静态库 

other: 一些资源文件得建立`.bundle`最后加入

```bash
#!/bin/sh

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
```