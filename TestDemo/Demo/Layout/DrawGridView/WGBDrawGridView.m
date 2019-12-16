//
// WGBDrawGridView.m
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
    

#import "WGBDrawGridView.h"

NSInteger const WGBGridViewRow = 9;
NSInteger const WGBGridViewCol = 9;

@implementation WGBDrawGridView



- (void)drawRect:(CGRect)rect {
    
    CGFloat positionY = .0;
    CGFloat positionX = .0;

    CGContextRef currentRef = UIGraphicsGetCurrentContext();
    for (NSInteger j = 1; j < WGBGridViewCol; j ++) {
        positionY = rect.size.height;
        positionX += rect.size.width / WGBGridViewCol;
        CGContextMoveToPoint(currentRef, positionX, 0);
        CGContextAddLineToPoint(currentRef, positionX, positionY);
        CGContextSetLineWidth(currentRef, 1.0);
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [ranColor setStroke];
        CGContextStrokePath(currentRef);
    }
    
    positionY = .0;
    for (NSInteger i = 1; i < WGBGridViewRow; i++) {
        positionY += rect.size.height / WGBGridViewRow;
        positionX = rect.size.width;
        CGContextMoveToPoint(currentRef, 0, positionY);
        CGContextAddLineToPoint(currentRef, positionX, positionY);
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [ranColor setStroke];
        CGContextStrokePath(currentRef);
    }
    
    /**
        CGContextSetLineWidth(ref, 1.0);
        [[UIColor grayColor] setStroke];
        CGContextStrokePath(ref);
     */
}


@end
