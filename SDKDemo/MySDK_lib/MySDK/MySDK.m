//
//  MySDK.m
//  MySDK
//
//  Created by 王贵彬(lu.com) on 2022/1/24.
//

#import "MySDK.h"

@implementation MySDK
+ (void)sdkVersion{
    NSLog(@"MySDK v1.0.0 ");
}
+ (void)startRecord{
    NSLog(@"开始录制⏺");
}
+ (void)stopRecord{
    NSLog(@"结束录制⏹");
}

@end
