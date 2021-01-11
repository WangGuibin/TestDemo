//
//  WGBGetImageKit.m
//  WGBTestStaticFramework
//
//  Created by 王贵彬 on 2021/1/10.
//

#import "WGBGetImageKit.h"

@implementation WGBGetImageKit
+ (UIImage *)getJPGImage{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:@"2" ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)getPNGImage{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png" inDirectory:@"WGBTestPackLib.bundle"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
