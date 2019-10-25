//
//  UIImage+MaskExtension.h
//  TestDemo
//
//  Created by mac on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MaskExtension)

/// MARK:- 画一个蒙层图片
/// @param tipRect 高亮的区域 (目标视图在窗口上的位置区域)    CGRect rect = [tempView convertRect:tempView.bounds toView:[UIApplication sharedApplication].delegate.window];

/// @param tipRectRadius 补偿区域圆角
/// @param bgColor 背景蒙层颜色
+ (UIImage *)imageWithTipRect:(CGRect)tipRect
               tipRectRadius:(CGFloat)tipRectRadius
                      bgColor:(UIColor *)bgColor;


/// MARK:- 利用贝塞尔曲线 绘制不规则特殊图形的蒙层
/// @param rectBounds 区域范围
/// @param path 图形路径
/// @param maskBgColor 蒙层背景色
+ (UIImage *)createMaskImageWithRectBounds:(CGRect)rectBounds
                                 shapePath:(UIBezierPath *)path
                       maskBackgroundColor:(UIColor *)maskBgColor ;

@end

NS_ASSUME_NONNULL_END
