//
//  WGBTestPackLib.m
//  WGBTestPackLib
//
//  Created by 王贵彬 on 2021/1/9.
// 参考了文章: https://www.jianshu.com/p/a9b886c99584
//
//

#import "WGBTestPackLib.h"

@implementation WGBTestPackLib

+ (UIImage *)getJPGImage{
    //方式① 寻找bundle获取path
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"WGBTestPackLib" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:@"2" ofType:@"jpg"];
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)getPNGImage{
    //方式② 直接找到bundle目录获取图片资源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png" inDirectory:@"WGBTestPackLib.bundle"];
    return [UIImage imageWithContentsOfFile:path];
}


@end
