//
//  WGBLogBackupManager.h
//  WGBLogBackupManager
//
//  Created by 王贵彬 on 2021/1/28.
//

#import <Foundation/Foundation.h>

#define WGBLog(FORMAT, ... )  [WGBLogBackupManager customLogWithFunction:(__FUNCTION__) lineNumber:(__LINE__) format:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]]

NS_ASSUME_NONNULL_BEGIN

@interface WGBLogBackupManager : NSObject

/// 设置log打印开关
/// @param enable 默认YES
+ (void)setLogEnable:(BOOL)enable;

/// 自定义Log 因为系统自带的NSLog经常出现打印不全的问题
/// @param func 方法名
/// @param line 方法调用所在行号
/// @param format 自定义打印的内容
+ (void)customLogWithFunction:(const char*)func
                   lineNumber:(int)line
                       format:(const char*)format;

/// 将控制台打印记录备份到沙盒,日志文件📃存放在Documents/Logs/目录下
+ (void)backupLog2SandBox;

@end

NS_ASSUME_NONNULL_END
