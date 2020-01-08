//
// WGBClipImageView.m
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
    

#import "WGBClipImageView.h"
#import "WGBClipBorderView.h"

@interface WGBClipImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//源图片容器
@property (nonatomic, strong) UIImageView *originImgView;
//裁剪框
@property (nonatomic, strong) WGBClipBorderView *clipBorder;
//蒙层
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation WGBClipImageView

@synthesize borderType = _borderType;
@synthesize aspectRatio = _aspectRatio;
@synthesize originImage = _originImage;

#pragma mark - lazy loading
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.clipsToBounds = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)originImgView
{
    if (_originImgView == nil)
    {
        _originImgView = [[UIImageView alloc] init];
        _originImgView.userInteractionEnabled = YES;
    }
    return _originImgView;
}

- (UIView *)maskView
{
    if (_maskView == nil)
    {
        _maskView = [[UIView alloc] init];
        _maskView.userInteractionEnabled = NO;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _maskView;
}

- (WGBClipBorderView *)clipBorder
{
    if (_clipBorder == nil)
    {
        _clipBorder = [[WGBClipBorderView alloc] init];
        _clipBorder.userInteractionEnabled = NO;
    }
    return _clipBorder;
}


///MARK: - <WGBClipImageProtocol>
- (void)setupContainerSubViews{
    self.aspectRatio = 1.0f;
    self.clipsToBounds = YES;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.originImgView];
    [self addSubview:self.maskView];
    [self addSubview:self.clipBorder];
}

- (void)layoutContainerSubViews{
    self.maskView.frame = self.bounds;
    CGFloat imageWidth = MAX(self.originImage.size.width, 1);
    CGFloat imageHeight = MAX(self.originImage.size.height, 1);
    if (imageWidth > imageHeight)
    {
        //横向
        CGFloat originImgHeight = CGRectGetWidth(self.frame) * imageHeight / imageWidth;
        self.originImgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), originImgHeight);
        //计算clipWindow初始位置
        if (self.aspectRatio > 1 && self.aspectRatio * imageHeight > imageWidth)
        {
            //clipWindow的宽度以self.frame.size.width为主
            CGFloat clipWindowW = self.frame.size.width * 3 / 4.0;
            CGFloat clipWindowH = clipWindowW / self.aspectRatio;
            self.clipBorder.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - clipWindowH) * 0.5, clipWindowW, clipWindowH);
        } else {
            //clipWindow的高度以originImgHeight为主
            CGFloat clipWindowH = originImgHeight * 3 / 4.0;
            CGFloat clipWindowW = clipWindowH * self.aspectRatio;
            self.clipBorder.frame = CGRectMake((CGRectGetWidth(self.frame) - clipWindowW) * 0.5, (CGRectGetHeight(self.frame) - clipWindowH) * 0.5, clipWindowW, clipWindowH);
        }
    } else {
        CGFloat originImgWidth = CGRectGetHeight(self.frame) * imageWidth / imageHeight;
        self.originImgView.frame = CGRectMake(0, 0, originImgWidth, CGRectGetHeight(self.frame));
        //计算clipWindow初始位置
        if (self.aspectRatio < 1 && self.aspectRatio *imageHeight < imageWidth)
        {
            //clipBorder的高度以self.frame.size.height为主
            CGFloat clipWindowH = self.frame.size.height * 3 / 4.0;
            CGFloat clipWindowW = clipWindowH * self.aspectRatio;
            self.clipBorder.frame = CGRectMake((CGRectGetWidth(self.frame) - clipWindowW) * 0.5, (CGRectGetHeight(self.frame) - clipWindowH) * 0.5, clipWindowW, clipWindowH);
        } else {
            //clipBorder的宽度以originImgWidth为主
            CGFloat clipWindowW = originImgWidth * 3 / 4.0;
            CGFloat clipWindowH = clipWindowW / self.aspectRatio;
            self.clipBorder.frame = CGRectMake((CGRectGetWidth(self.frame) - clipWindowW) * 0.5, (CGRectGetHeight(self.frame) - clipWindowH) * 0.5, clipWindowW, clipWindowH);
        }
    }
    self.scrollView.frame = self.clipBorder.frame;
    self.originImgView.center = CGPointMake(self.scrollView.frame.size.width * 0.5, self.scrollView.frame.size.height * 0.5);
    self.scrollView.contentSize = self.originImgView.frame.size;
    //调整originImgView中心
    [self scrollViewDidZoom:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake((CGRectGetWidth(self.originImgView.frame) - CGRectGetWidth(self.scrollView.frame)) * 0.5, (CGRectGetHeight(self.originImgView.frame) - CGRectGetHeight(self.scrollView.frame)) * 0.5) animated:NO];
    self.clipBorder.borderType = self.borderType;
    [self resetClipWindowTransparentArea];
}

- (UIImage *)getClipedResultImage
{
    CGFloat scaleFactorX = self.originImage.size.width * self.originImage.scale / (self.originImgView.frame.size.width / self.scrollView.zoomScale);
    CGFloat scaleFactorY = self.originImage.size.height * self.originImage.scale / (self.originImgView.frame.size.height / self.scrollView.zoomScale);
    CGRect rect = [self.clipBorder convertRect:self.clipBorder.bounds toView:self.originImgView];
    rect = CGRectMake(CGRectGetMinX(rect) * scaleFactorX, CGRectGetMinY(rect) * scaleFactorY, CGRectGetWidth(rect) * scaleFactorX, CGRectGetHeight(rect) * scaleFactorY);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.originImage CGImage], rect);
    UIImage* newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, 0);
    UIBezierPath *clipPath = [UIBezierPath bezierPath];
    if (self.borderType == WGBClipBorderTypeRound)
    {
        clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    }else if (self.borderType == WGBClipBorderTypeRectangle){
        clipPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, newImage.size.width , newImage.size.height)];
    }
    else {
        [clipPath moveToPoint:CGPointMake(newImage.size.width * 0.5, 0)];
        [clipPath addLineToPoint:CGPointMake(0, newImage.size.height)];
        [clipPath addLineToPoint:CGPointMake(newImage.size.width, newImage.size.height)];
        [clipPath closePath];
    }
    [clipPath addClip];
    [newImage drawAtPoint:CGPointZero];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - private methods
- (void)resetClipWindowTransparentArea
{
    if (self.maskLayer && self.maskLayer.superlayer)
    {
        [self.maskLayer removeFromSuperlayer];
    }
    self.maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    UIBezierPath *clearPath;
    switch (self.borderType) {
        case WGBClipBorderTypeRound:
        {
            clearPath = [[UIBezierPath bezierPathWithOvalInRect:self.clipBorder.frame] bezierPathByReversingPath];
        }
            break;
        case WGBClipBorderTypeRectangle:
        {
            clearPath = [[UIBezierPath bezierPathWithRect:self.clipBorder.frame] bezierPathByReversingPath];
        }
            break;
        case WGBClipBorderTypeTriangle:
        {
            clearPath = [[UIBezierPath bezierPath] bezierPathByReversingPath];
            [clearPath moveToPoint:CGPointMake(CGRectGetMidX(self.clipBorder.frame), CGRectGetMinY(self.clipBorder.frame))];
            [clearPath addLineToPoint:CGPointMake(CGRectGetMinX(self.clipBorder.frame), CGRectGetMaxY(self.clipBorder.frame))];
            [clearPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.clipBorder.frame), CGRectGetMaxY(self.clipBorder.frame))];
            [clearPath closePath];
        }
            break;
            
        default:
            break;
    }
    [path appendPath:clearPath];
    self.maskLayer.path = path.CGPath;
    self.maskView.layer.mask = self.maskLayer;
}

#pragma mark - setter
- (void)setAspectRatio:(CGFloat)aspectRatio
{
    _aspectRatio = aspectRatio;
    [self layoutContainerSubViews];
}

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    self.originImgView.image = originImage;
    [self layoutContainerSubViews];
}

- (void)setBorderType:(WGBClipBorderType)borderType{
    _borderType = borderType;
    [self layoutContainerSubViews];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.originImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.originImgView.center = CGPointMake(self.scrollView.contentSize.width * 0.5, self.scrollView.contentSize.height * 0.5);
}


@end
