//
// WGBAnimationFlowButton.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/23
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
    
#import "WGBAnimationFlowButton.h"

@interface WGBAnimationFlowButton ()

@property (nonatomic, strong) UIView *maskBgView;
@property (nonatomic, assign) BOOL isAnimationed;

@end

@implementation WGBAnimationFlowButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.isAnimationed = NO;
    self.animationInterval = 3.0f;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.maskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setFlowBgColor:(UIColor *)flowBgColor{
    _flowBgColor = flowBgColor;
    self.maskBgView.backgroundColor = flowBgColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.isAnimationed) {
        self.isAnimationed = YES;
        [self showAnimation];
    }
}

- (void)showAnimation{
    [self showMaskLayerAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAnimation];
    });
}

- (void)showMaskLayerAnimation{
    CALayer *maskLayer = [CALayer layer];
    UIImage *maskImage = [UIImage imageNamed:@"flow_mask.png"];
    maskLayer.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    self.maskBgView.layer.mask = maskLayer;
    self.maskBgView.hidden = NO;
    //基础动画
    CABasicAnimation *flowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat width = maskLayer.frame.size.width > self.width ? maskLayer.frame.size.width : self.width;
    flowAnimation.fromValue = [NSNumber numberWithFloat: -width/2.0];
    flowAnimation.toValue = [NSNumber numberWithFloat:self.width];
    flowAnimation.duration = 1.0;
    flowAnimation.repeatCount = 0;
    flowAnimation.removedOnCompletion = NO;
    flowAnimation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:flowAnimation forKey:@"xxxxxxxxxKey"];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        _button.backgroundColor = [UIColor blackColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button setTitle:@"按钮" forState:UIControlStateNormal];
        [self addSubview:_button];
     }
    return _button;
}


- (UIView *)maskBgView {
    if (!_maskBgView) {
        _maskBgView = [[UIView alloc] initWithFrame:CGRectZero];
        //重要!! 设置mask的话 宿主背景色一定要有 不然看不见效果的
        _maskBgView.backgroundColor = [UIColor whiteColor];
        _maskBgView.hidden = YES;
        [self addSubview:_maskBgView];
    }
    return _maskBgView;
}

@end
