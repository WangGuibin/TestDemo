//
//  WGBLogBackupManager.m
//  WGBLogBackupManager
//
//  Created by 王贵彬 on 2021/1/28.
//

#import "WGBLogBackupManager.h"

static BOOL __logEnable = YES;

@implementation WGBLogBackupManager

/// 设置log打印开关
/// @param enable 默认YES
+ (void)setLogEnable:(BOOL)enable{
    __logEnable = enable;
}


/// 自定义Log 因为系统自带的NSLog经常出现打印不全的问题
/// @param func 方法名
/// @param line 方法调用所在行号
/// @param format 自定义打印的内容
+ (void)customLogWithFunction:(const char*)func
                   lineNumber:(int)line
                       format:(const char*)format{
    if (__logEnable) {
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"yyyy-mm-dd hh:MM:ss.SSS"];
        NSString *dateStr = [dateFormat stringFromDate:[NSDate date]];
        ///输出到屏幕
        fprintf(stderr,"⎾WGBLog⏌==>%s function:%s [line:%d]:\n%s\n",[dateStr UTF8String], func, line, format);
        fflush(stderr);
        ///写入磁盘
        fprintf(stdout,"⎾WGBLog⏌==>%s function:%s [line:%d]:\n%s\n",[dateStr UTF8String], func, line, format);
        fflush(stdout);
    }
}

/// 将控制台打印记录备份到沙盒,日志文件📃存放在Documents/Logs/目录下
+ (void)backupLog2SandBox{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    NSString *fileName = [NSString stringWithFormat:@"Log-%@.txt",[dateformat stringFromDate:[NSDate date]]];

    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [documentDirectory stringByAppendingPathComponent:@"Logs"];
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:dirPath]) {
        [defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    WGBLog(@"%@",filePath);
    /// 将log写入到沙盒文件
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
        
}


@end
