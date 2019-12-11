//
// WGBLoadingView.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/11
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
    

#import "WGBLoadingView.h"

@interface WGBLoadingView ()

@property (nonatomic,strong) CAReplicatorLayer * replictorLayer;


@end

@implementation WGBLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder  {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (CAReplicatorLayer *)replictorLayer {
    
    if (!_replictorLayer) {
        _replictorLayer = [CAReplicatorLayer layer];
    }
    return _replictorLayer;
}

- (CALayer *)loadingLayer {
    
    if (!_loadingLayer) {
        _loadingLayer = [CALayer layer];
        _loadingLayer.transform = CATransform3DMakeScale(0, 0, 0);
        _loadingLayer.cornerRadius = 2.5;
        _loadingLayer.masksToBounds = YES;
        //颜色可自定义 或者使用渐变layer 花里胡哨的
        _loadingLayer.backgroundColor = [UIColor redColor].CGColor;
    }
    return _loadingLayer;
}

- (void)setupSubviews {
    [self.layer addSublayer:self.replictorLayer];
    [self.replictorLayer addSublayer:self.loadingLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, 30, 30);
    self.center = self.superview.center;
    
    self.replictorLayer.frame = self.bounds;
    self.loadingLayer.position = CGPointMake(self.bounds.size.width * 0.5f, 0);
    self.loadingLayer.bounds = CGRectMake(0, 0, 5, 5);
    
    int count = 15;
    CGFloat angle = M_PI * 2 / count;
    
    self.replictorLayer.instanceCount = count;
    self.replictorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);

    CABasicAnimation * anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.fromValue = @1;
    anim.toValue = @0;
    anim.repeatDuration = MAXFLOAT;
    CGFloat duration = 1;
    anim.duration = duration;
    [self.loadingLayer addAnimation:anim forKey:nil];
    self.replictorLayer.instanceDelay = duration / count;
}


@end
