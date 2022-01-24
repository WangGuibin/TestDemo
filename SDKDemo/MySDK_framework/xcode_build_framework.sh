set -e
#SDK的名字
SDK_NAME=${PROJECT_NAME}
#SDK产出目录
INSTALL_DIR=${SRCROOT}/Products/${SDK_NAME}.framework

#清空编译缓存
rm -rf ${BUILD_DIR}

# 执行模拟器编译指令
xcodebuild -configuration ${CONFIGURATION} -target "${SDK_NAME}" -sdk iphonesimulator build
#执行真机编译指令
xcodebuild -configuration ${CONFIGURATION} -target "${SDK_NAME}" -sdk iphoneos  build

#真机目录
DEVICE_DIR="build"/${CONFIGURATION}-iphoneos/${SDK_NAME}.framework
#模拟器目录
SIMULATOR_DIR="build"/${CONFIGURATION}-iphonesimulator/${SDK_NAME}.framework

#清除旧的安装目录
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
#创建新的安装目录
mkdir -p "${INSTALL_DIR}"
#拷贝编译产物到安装目录
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

#合并真机和模拟器的编译产物
lipo -create "${DEVICE_DIR}/${SDK_NAME}" "${SIMULATOR_DIR}/${SDK_NAME}" -output "${INSTALL_DIR}/${SDK_NAME}"

#打开安装目录查看结果
open "${SRCROOT}/Products/"

rm -rf "${SRCROOT}/build"

#查看此次编译的架构支持
lipo_info=`lipo -info ${INSTALL_DIR}/${SDK_NAME}`
icon_path=`pwd`/Xcode.icns
icon_file=$(osascript -e "set thePath to POSIX file \"${icon_path}\" as string")
echo $icon_file
archs=${lipo_info##are:*}
osascript -e "display dialog \"${archs}\" with title \"查看静态库信息\" buttons {\"OK\"} default button 1 with icon file \"${icon_file}\""
echo "脚本跑🏃完了"



