//
// WGBConfettiTypeModel.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/4
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
    

#import "WGBConfettiTypeModel.h"

@interface WGBConfettiTypeModel()


@end

@implementation WGBConfettiTypeModel

- (instancetype)initWithColor:(UIColor *)color
                        shape:(WGBConfettiShape)shape
                     position:(WGBConfettiPosition)position
{
    self = [super init];
    if (self) {
        self.color = color;
        self.shape = shape;
        self.position = position;
        [self createImage];
    }
    return self;
}

- (void)createImage
{
    CGRect imageRect = CGRectZero;
    if (self.shape == WGBConfettiShapeRectangle) {
        imageRect = CGRectMake(0, 0, 20 , 13);
    }else{
        imageRect = CGRectMake(0, 0, 10 , 10);
    }
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.color setFill];
    if (self.shape == WGBConfettiShapeRectangle) {
        CGContextFillRect(context, imageRect);
    }else{
        CGContextFillEllipseInRect(context, imageRect);
    }
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextFillPath(context);
    UIGraphicsEndImageContext();
}


@end
