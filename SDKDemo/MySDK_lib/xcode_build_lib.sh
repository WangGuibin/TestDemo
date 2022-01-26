<<EOF
#注释说明: 保存本文件名为xcode_build_lib.sh,放到工程根目录即可
# Aggregate里新建RunScript 调用如下:
#一键产出通用包 传参指定架构打包
sh xcode_build_lib.sh "armv7,armv7s,arm64,arm64e,x86_64,i386"
#sh xcode_build_lib.sh  # 不传参则弹出GUI选择菜单
EOF

set -e
#SDK的名字
SDK_NAME=${PROJECT_NAME}
#SDK产出目录
INSTALL_DIR=${SRCROOT}/Products/${SDK_NAME}

#清空编译缓存
rm -rf ${BUILD_DIR}

if [ "x$1" = "x" ] ; #无入参则弹窗去选择
then
#弹出选择架构菜单
select_arch=$(osascript <<EOF
choose from list {"i386","x86_64","armv7","armv7s","arm64","arm64e"} with title "指定架构编译SDK" with prompt "选择架构" OK button name "编译" cancel button name "取消" default items {"armv7","arm64"} with multiple selections allowed
EOF
)
else
#输入指定架构 "arm64,armv7,..." 用逗号隔开即可
select_arch=${1}
fi
# 默认已选择armv7和arm64 点取消才会走这里
if [[ $select_arch = false ]] ;
then
    echo "未选择架构,已取消本次编译."
    exit 0;
fi

simulator_archs=()
if [[ $select_arch =~ "i386" ]] ;
then
    simulator_archs+=("i386")
fi

if [[ $select_arch =~ "x86_64" ]] ;
then
    simulator_archs+=("x86_64")
fi

echo "模拟器架构为: "${simulator_archs[*]}

#模拟器架构个数,如果个数为0,则不需要模拟器参与编译了
simulator_archs_length=${#simulator_archs[*]}
if [[ $simulator_archs_length == 0 ]] ;
then
    echo "模拟器架构数为0,模拟器无需参与编译"
else
    # 剔除模拟器架构
    select_arch=${select_arch//i386/ }
    select_arch=${select_arch//x86_64/ }
fi

# 获取真机的架构
iphoneos_archs=(${select_arch//,/ })
echo "真机架构为: "${iphoneos_archs[*]}

if [[ $simulator_archs_length > 0 ]] ;
then
# 执行模拟器编译指令
xcodebuild -configuration ${CONFIGURATION} -target "${SDK_NAME}" -sdk iphonesimulator build ARCHS="${simulator_archs[*]}"
fi

#执行真机编译指令
xcodebuild -configuration ${CONFIGURATION} -target "${SDK_NAME}" -sdk iphoneos  build ARCHS="${iphoneos_archs[*]}"

#真机目录
DEVICE_DIR="build"/${CONFIGURATION}-iphoneos
#模拟器目录
SIMULATOR_DIR="build"/${CONFIGURATION}-iphonesimulator

#清除旧的安装目录
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
#创建新的安装目录
mkdir -p "${INSTALL_DIR}"
#拷贝编译产物到安装目录
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
rm -rf "${INSTALL_DIR}/usr"

# 有模拟器编译才需要合并
if [[ $simulator_archs_length > 0 ]] ;
then
#合并真机和模拟器的编译产物
lipo -create "${DEVICE_DIR}/lib${SDK_NAME}.a" "${SIMULATOR_DIR}/lib${SDK_NAME}.a" -output "${INSTALL_DIR}/lib${SDK_NAME}.a"
fi

#打开安装目录查看结果
open "${SRCROOT}/Products/"
#删除编译冗余数据
rm -rf "${SRCROOT}/build"

#查看此次编译的架构支持
lipo_info=`lipo -info ${INSTALL_DIR}/lib${SDK_NAME}.a`
icon_path=`pwd`/Xcode.icns
icon_file=$(osascript -e "set thePath to POSIX file \"${icon_path}\" as string")
echo $icon_file
osascript -e "display dialog \"SDK包含架构: ${lipo_info##*are:}\" with title \"当前SDK架构信息\" buttons {\"OK\"} default button 1 with icon file \"${icon_file}\""
echo "脚本跑🏃完了"
