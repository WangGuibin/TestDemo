//
//  RPRecorder.m
//  MySDK
//
//  Created by 王贵彬(lu.com) on 2022/1/24.
//

#import "RPRecorder.h"

@implementation RPRecorder

+ (void)sdkVersion{
    NSLog(@"RPRecorder v1.0.0 ");
}
+ (void)startRecord{
    NSLog(@"开始录制⏺");
}
+ (void)stopRecord{
    NSLog(@"结束录制⏹");
}

@end
