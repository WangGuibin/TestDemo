//
// WGBPopupViewWrapper.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/25
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
    

#import "WGBPopupViewWrapper.h"

@protocol WGBPopupViewWrapperProtocol <NSObject>

@property (nonatomic, weak) WGBPopupViewWrapper *wrapper;

@end


@implementation WGBPopupViewWrapper
{
    id<WGBPopupViewProtocol> _popupView;
}

- (instancetype)initWithView:(id<WGBPopupViewProtocol>)popupView
{
    if (self = [super init]) {
        _popupView = popupView;
        ((id<WGBPopupViewWrapperProtocol>)_popupView).wrapper = self;
    }
    return self;
}

- (UIView *)show:(UIView*)parentView
{
    UIView *view = [_popupView show:parentView];
    
    if (self.bgColor) self.backgroundColor = self.bgColor;
    self.frame = parentView.bounds;
    [self addTarget:self action:@selector(onBkgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [parentView insertSubview:self belowSubview:view];
    return nil;
}

- (void)hide
{
    if (self.hideHandler) self.hideHandler();
    [self removeFromSuperview];
}

- (void)onBkgButtonClicked:(id)sender
{
    [_popupView hide];
}

@end

@interface WGBPopupView () <WGBPopupViewWrapperProtocol>

@end

@implementation WGBPopupView

@synthesize wrapper;

- (UIView*)show:(UIView *)parentView
{
    [parentView addSubview:self];
    return self;
}

- (void)hide
{
    [self removeFromSuperview];
    
    [self.wrapper hide];
}

@end

@interface WGBPopupObject () <WGBPopupViewWrapperProtocol>

@end

@implementation WGBPopupObject

@synthesize wrapper;

- (UIView *)show:(UIView *)parentView
{
    return nil;
}

- (void)hide
{
    [self.wrapper hide];
}

@end
