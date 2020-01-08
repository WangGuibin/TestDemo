//
// WGBClipImageContainerView.m
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
    

#import "WGBClipImageContainerView.h"
#import "WGBClipFrameView.h"
#import "WGBClipImageView.h"

@interface WGBClipImageContainerView ()

@property (nonatomic, strong) WGBClipFrameView *adjustFrameView;
@property (nonatomic, strong) WGBClipImageView *adjustImageView;

@property (nonatomic, strong, readwrite) UIView<WGBClipImageProtocol> *clipView;

@end


@implementation WGBClipImageContainerView

#pragma mark - lazy loading
- (WGBClipFrameView *)adjustFrameView
{
    if (_adjustFrameView == nil)
    {
        _adjustFrameView = [[WGBClipFrameView alloc] init];
    }
    return _adjustFrameView;
}

- (WGBClipImageView *)adjustImageView
{
    if (_adjustImageView == nil)
    {
        _adjustImageView = [[WGBClipImageView alloc] init];
    }
    return _adjustImageView;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

#pragma mark - setupBase
- (void)setupBase
{
    //默认
    self.backgroundColor = [UIColor clearColor];
    self.borderType = WGBClipBorderTypeRectangle;
    self.aspectRatio = 1.0;
    self.originImage = [UIImage imageNamed:@"landscape.jpg"];
    self.clipStyle = WGBClipStyleFrame;
    //布局
    [self.clipView setupContainerSubViews];
    [self addSubview:self.clipView];
}

#pragma mark - setter
- (void)setClipStyle:(WGBClipStyle)clipStyle{
    [self.clipView removeFromSuperview];
    _clipStyle = clipStyle;
    self.clipView = (clipStyle == WGBClipStyleFrame)?self.adjustFrameView : self.adjustImageView;
    self.clipView.aspectRatio = self.aspectRatio;
    self.clipView.borderType = self.borderType;
    self.clipView.originImage = self.originImage;
    //布局
    [self.clipView setupContainerSubViews];
    [self addSubview:(UIView *)self.clipView];
}

- (void)setBorderType:(WGBClipBorderType)borderType
{
    _borderType = borderType;
    self.clipView.borderType = borderType;
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    _aspectRatio = aspectRatio;
    self.clipView.aspectRatio = aspectRatio;
}

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    self.clipView.originImage = originImage;
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.clipView.frame = self.bounds;
    [self.clipView layoutContainerSubViews];
}

@end
