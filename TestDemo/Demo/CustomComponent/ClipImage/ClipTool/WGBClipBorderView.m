//
// WGBBorderView.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/1/7
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
    

#import "WGBClipBorderView.h"

@interface WGBClipBorderView()

@property (nonatomic, strong) CAShapeLayer *roundLayer;
@property (nonatomic, strong) CAShapeLayer *rectangleLayer;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;

@end


@implementation WGBClipBorderView

static const CGFloat safeArea = 30.f;

#pragma mark - setter
- (void)setBorderType:(WGBClipBorderType)borderType{
    _borderType = borderType;
    if (self.rectangleLayer && self.rectangleLayer.superlayer)
    {
        [self.rectangleLayer removeFromSuperlayer];
    }
    if (self.roundLayer && self.roundLayer.superlayer)
    {
        [self.roundLayer removeFromSuperlayer];
    }
    switch (borderType) {
        case WGBClipBorderTypeRectangle:
        {
            [self createRectangleLayer];
        }
            break;
        case WGBClipBorderTypeRound:
        {
            [self createRoundLayer];
        }
            break;
        case WGBClipBorderTypeTriangle:
        {
            [self createTriangleLayer];
        }
            break;
            
        default:
            break;
    }
}

- (void)createTriangleLayer
{
    if (self.triangleLayer && self.triangleLayer.superlayer)
    {
        [self.triangleLayer removeFromSuperlayer];
    }
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.triangleLayer.fillColor = [UIColor clearColor].CGColor;
    self.triangleLayer.lineWidth = 2.f;
    self.triangleLayer.lineJoin = kCALineJoinRound;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.frame.size.width * 0.5, 0)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path closePath];
    self.triangleLayer.path = path.CGPath;
    [self.layer addSublayer:self.triangleLayer];
}

- (void)createRoundLayer
{
    if (self.roundLayer && self.roundLayer.superlayer)
    {
        [self.roundLayer removeFromSuperlayer];
    }
    self.roundLayer = [CAShapeLayer layer];
    self.roundLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.roundLayer.fillColor = [UIColor clearColor].CGColor;
    self.roundLayer.lineWidth = 2.f;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [path moveToPoint:CGPointMake(0, self.frame.size.height * 0.5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height * 0.5)];
    [path moveToPoint:CGPointMake(self.frame.size.width * 0.5, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height)];
    self.roundLayer.path = path.CGPath;
    [self.layer addSublayer:self.roundLayer];
}

- (void)createRectangleLayer
{
    if (self.rectangleLayer && self.rectangleLayer.superlayer)
    {
        [self.rectangleLayer removeFromSuperlayer];
    }
    self.rectangleLayer = [CAShapeLayer layer];
    self.rectangleLayer.strokeColor = [UIColor yellowColor].CGColor;
    self.rectangleLayer.fillColor = [UIColor clearColor].CGColor;
    self.rectangleLayer.lineWidth = 2.f;
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:self.bounds];
    [rectanglePath moveToPoint:CGPointMake(self.frame.size.width / 3.f, 0)];
    [rectanglePath addLineToPoint:CGPointMake(self.frame.size.width / 3.f, self.frame.size.height)];
    
    [rectanglePath moveToPoint:CGPointMake(self.frame.size.width * 2 / 3.f, 0)];
    [rectanglePath addLineToPoint:CGPointMake(self.frame.size.width * 2 / 3.f, self.frame.size.height)];
    
    [rectanglePath moveToPoint:CGPointMake(0, self.frame.size.height / 3.f)];
    [rectanglePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height / 3.f)];
    
    [rectanglePath moveToPoint:CGPointMake(0, self.frame.size.height * 2 / 3.f)];
    [rectanglePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height * 2 / 3.f)];
    self.rectangleLayer.path = rectanglePath.CGPath;
    [self.layer addSublayer:self.rectangleLayer];
}

#pragma mark - public methods
- (UIBezierPath *)getCurrentBorderPath
{
    switch (self.borderType) {
        case WGBClipBorderTypeRound:
            return [UIBezierPath bezierPathWithCGPath:self.roundLayer.path];
        case WGBClipBorderTypeRectangle:
            return [UIBezierPath bezierPathWithCGPath:self.rectangleLayer.path];
        case WGBClipBorderTypeTriangle:
            return [UIBezierPath bezierPathWithCGPath:self.triangleLayer.path];
        default:
            goto fail;
            break;
    }
    goto fail;
fail:
    NSAssert(0, @"请正确设置borderType");
}

- (WGBClipBorderDragOptions)getClipBorderDragOptions:(CGPoint)location
{
    if (location.x > safeArea &&
        location.x < self.frame.size.width - safeArea &&
        location.y > -safeArea &&
        location.y < safeArea) {
        
        return WGBClipBorderDragOptionsTop;
    } else if (location.x > -safeArea &&
               location.x < safeArea &&
               location.y > safeArea &&
               location.y < self.frame.size.height - safeArea) {
        
        return WGBClipBorderDragOptionsLeft;
    } else if (location.x > safeArea &&
               location.x < self.frame.size.width - safeArea &&
               location.y > self.frame.size.height - safeArea &&
               location.y < self.frame.size.height + safeArea) {
        
        return WGBClipBorderDragOptionsBottom;
    } else if (location.x > self.frame.size.width - safeArea &&
               location.x < self.frame.size.width + safeArea &&
               location.y > safeArea &&
               location.y < self.frame.size.height - safeArea) {
        
        return WGBClipBorderDragOptionsRight;
    } else if (location.x > -safeArea &&
               location.x < safeArea &&
               location.y > -safeArea &&
               location.y < safeArea) {
        
        return WGBClipBorderDragOptionsTop | WGBClipBorderDragOptionsLeft;
    } else if (location.x > -safeArea &&
               location.x < safeArea &&
               location.y > self.frame.size.height - safeArea &&
               location.y < self.frame.size.height + safeArea) {
        
        return WGBClipBorderDragOptionsBottom | WGBClipBorderDragOptionsLeft;
    } else if (location.x > self.frame.size.width - safeArea &&
               location.x < self.frame.size.width + safeArea &&
               location.y > -safeArea &&
               location.y < safeArea) {
        
        return WGBClipBorderDragOptionsTop | WGBClipBorderDragOptionsRight;
    } else if (location.x > self.frame.size.width - safeArea &&
               location.x < self.frame.size.width + safeArea &&
               location.y > self.frame.size.height - safeArea &&
               location.y < self.frame.size.height + safeArea) {
        
        return WGBClipBorderDragOptionsBottom | WGBClipBorderDragOptionsRight;
    }
    return WGBClipBorderDragOptionsNone;
}

#pragma mark - layoutLayer
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.borderType = _borderType;
}
@end
