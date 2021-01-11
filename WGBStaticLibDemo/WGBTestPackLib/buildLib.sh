#! /bin/sh
# 先在工程根目录创建好SDK文件夹
mkdir -p ${PROJECT_NAME}_SDK
cd ${PROJECT_NAME}_SDK
mkdir -p ${PROJECT_NAME}
cd ${PROJECT_NAME}
mkdir -p include
mkdir -p lib

#回到工程目录
cd ./../../
#真机build生成的.a文件路径
DEVICE_DIR_A=${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}.a
#模拟器build生成的.a文件路径
SIMULATOR_DIR_A=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}.a

if [[ -f "${DEVICE_DIR_A}" ]]; then
	say "真机编译完成"
fi

if [[ -f "${SIMULATOR_DIR_A}" ]]; then
	say "模拟器编译完成"
fi

if [[ -f "${DEVICE_DIR_A}" ]] ; then
	if [[ -f "${SIMULATOR_DIR_A}" ]]; then
		lipo -create ${DEVICE_DIR_A} ${SIMULATOR_DIR_A} -output ./${PROJECT_NAME}_SDK/${PROJECT_NAME}/lib/lib${PROJECT_NAME}.a
		#头文件转移大法
		HEADER_FOLDER="${BUILD_DIR}/${CONFIGURATION}-iphoneos/include/${PROJECT_NAME}"
		cp -a ${HEADER_FOLDER}/. ./${PROJECT_NAME}_SDK/${PROJECT_NAME}/include
		open ./
		say "静态库合并成功"
	fi
fi

