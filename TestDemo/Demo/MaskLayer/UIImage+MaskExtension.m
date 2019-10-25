//
//  UIImage+MaskExtension.m
//  TestDemo
//
//  Created by mac on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UIImage+MaskExtension.h"

@implementation UIImage (MaskExtension)


/// MARK:- 画一个蒙层图片
/// @param tipRect 高亮的区域 (目标视图在窗口上的位置区域)    CGRect rect = [tempView convertRect:tempView.bounds toView:[UIApplication sharedApplication].delegate.window];

/// @param tipRectRadius 补偿区域圆角
/// @param bgColor 背景蒙层颜色
+ (UIImage *)imageWithTipRect:(CGRect)tipRect
               tipRectRadius:(CGFloat)tipRectRadius
                     bgColor:(UIColor *)bgColor{

    //开启当前的图形上下文
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0.0);
    
    // 获取图形上下文，画板
    CGContextRef cxtRef = UIGraphicsGetCurrentContext();
    
    //将提示框增大，并保持居中显示，默认增大尺寸为切圆角的半径，需要特殊处理改下面尺寸
    CGFloat plusSize = tipRectRadius;
    CGRect tipRectPlus = CGRectMake(tipRect.origin.x - plusSize * 0.5, tipRect.origin.y - plusSize * 0.5, tipRect.size.width + plusSize, tipRect.size.height + plusSize);
    
    //绘制提示路径
    UIBezierPath *tipRectPath = [UIBezierPath bezierPathWithRoundedRect:tipRectPlus cornerRadius:tipRectRadius];
    
    //绘制蒙版
    UIBezierPath *screenPath = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    
    //填充色，默认为半透明，灰黑色背景
    if (bgColor) {
        CGContextSetFillColorWithColor(cxtRef, bgColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(cxtRef, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
    }

    //添加路径到图形上下文
    CGContextAddPath(cxtRef, tipRectPath.CGPath);
    CGContextAddPath(cxtRef, screenPath.CGPath);
    
    //渲染，选择奇偶模式
    CGContextDrawPath(cxtRef, kCGPathEOFill);
    
    //从画布总读取图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}



/// MARK:- 利用贝塞尔曲线 绘制不规则特殊图形的蒙层
/// @param rectBounds 区域范围
/// @param path 图形路径
/// @param maskBgColor 蒙层背景色
+ (UIImage *)createMaskImageWithRectBounds:(CGRect)rectBounds
                                 shapePath:(UIBezierPath *)path
                       maskBackgroundColor:(UIColor *)maskBgColor {
    //开启当前的图形上下文
    UIGraphicsBeginImageContextWithOptions(rectBounds.size, NO, 0.0);
    
    // 获取图形上下文，画板
    CGContextRef cxtRef = UIGraphicsGetCurrentContext();
        
    //绘制蒙版
    UIBezierPath *screenPath = [UIBezierPath bezierPathWithRect:rectBounds];
    
    //填充色，默认为半透明，灰黑色背景
    if (maskBgColor) {
        CGContextSetFillColorWithColor(cxtRef, maskBgColor.CGColor);
    }else{
        CGContextSetFillColorWithColor(cxtRef, [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2].CGColor);
    }

    //添加路径到图形上下文
    CGContextAddPath(cxtRef, path.CGPath);
    CGContextAddPath(cxtRef, screenPath.CGPath);
    
    //渲染，选择奇偶模式
    CGContextDrawPath(cxtRef, kCGPathEOFill);
    
    //从画布总读取图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
