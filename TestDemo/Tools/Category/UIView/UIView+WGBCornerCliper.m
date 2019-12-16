//
// UIView+WGBCornerCliper.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/16
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "UIView+WGBCornerCliper.h"

@implementation UIView (WGBCornerCliper)

/// 添加圆角 调用时机：设置好布局之后调用 或者 调用`layoutIfNeed`之后使用
/// @param corners 圆角位置设置
/// @param radius 圆角大小
- (void)wgb_clipCorners:(UIRectCorner)corners
                 radius:(CGFloat)radius{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shapeLayer = self.layer.mask ?: [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

/// 添加圆角和边框, 调用时机：设置好布局之后调用 或者 调用`layoutIfNeed`之后使用
/// @param corners 圆角位置设置
/// @param radius 圆角大小
/// @param width 边框宽度
/// @param borderColor 边框颜色
/**
@code

[self.testView wgb_clipCorners:(UIRectCornerAllCorners) radius:5.0 border:1.0 borderColor:[UIColor redColor]];

@endcode
*/

- (void)wgb_clipCorners:(UIRectCorner)corners
                 radius:(CGFloat)radius
                 border:(CGFloat)width
            borderColor:(UIColor *)borderColor{
    [self wgb_clipCorners:corners radius:radius];
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.lineWidth = width * 2;
    subLayer.strokeColor = borderColor.CGColor;
    subLayer.fillColor = [UIColor clearColor].CGColor;
    subLayer.path = ((CAShapeLayer *)self.layer.mask).path;
    [self.layer addSublayer:subLayer];
}

@end
