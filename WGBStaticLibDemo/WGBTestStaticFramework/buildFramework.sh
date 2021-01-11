#! /bin/sh
#创建存放目录
mkdir -p ${PROJECT_NAME}.framework
INSTALL_DIR=./${PROJECT_NAME}.framework

#真机编译产物
DEVICE_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework
#模拟器编译产物
SIMULATOR_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework


if [[ -d "$DEVICE_DIR" ]]; then
	say "真机编译完成"
fi

if [[ -d "$SIMULATOR_DIR" ]]; then
	say "模拟器编译完成"
fi

if [[ -d "${DEVICE_DIR}" ]] ; then
	if [[ -d "${SIMULATOR_DIR}" ]]; then
		cp -R ${DEVICE_DIR}/ ${INSTALL_DIR}/
		lipo -create "${DEVICE_DIR}/${PROJECT_NAME}" "${SIMULATOR_DIR}/${PROJECT_NAME}" -output "${INSTALL_DIR}/${PROJECT_NAME}"
		open ./
		say "静态库合并成功"
	fi
fi