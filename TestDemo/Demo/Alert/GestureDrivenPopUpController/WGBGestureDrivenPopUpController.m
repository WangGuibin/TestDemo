//
// WGBGestureDrivenPopUpController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/7/27
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
    

#import "WGBGestureDrivenPopUpController.h"

@interface WGBGestureDrivenPopUpController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation WGBGestureDrivenPopUpController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scaleToDismiss = 0.25;
        self.spaceToTop = [UIScreen mainScreen].bounds.size.height / 3.0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    [self.view addSubview:self.baseView];
    [self.baseView addGestureRecognizer:self.panGestureRecognizer];
    [self roundedCorners:15 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight targetView:self.baseView];
}

- (void)addContentView:(UIView *)contentView {
    CGFloat bottom = [UIScreen mainScreen].bounds.size.height == 812 ? 88 : 64;
    contentView.frame = CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height - bottom);
    [self.baseView addSubview:contentView];
}

- (void)show {
    CGFloat top = [UIScreen mainScreen].bounds.size.height == 812 ? 88 : 64;
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height + top + self.spaceToTop);
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    } completion:NULL];
}

- (void)dismiss {
    [UIView animateWithDuration:0.7 animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    }];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        self.baseView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGFloat top = [UIScreen mainScreen].bounds.size.height == 812 ? 88 : 64;
    CGFloat offsetY = [sender translationInView:sender.view].y;
    if (offsetY >= 0) {
        [UIView animateWithDuration:0.13 animations:^{
            self.baseView.transform = CGAffineTransformMakeTranslation(0, -self.baseView.frame.size.height + top + offsetY);
        }];
    }
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
        if (offsetY >= (self.baseView.frame.size.height - top) *self.scaleToDismiss) {
            [self dismiss];
        } else {
            [self show];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        if (((UIScrollView *)otherGestureRecognizer.view).contentOffset.y <= 0) {
            ((UIScrollView *)otherGestureRecognizer.view).bounces = NO;
            return YES;
        }
        ((UIScrollView *)otherGestureRecognizer.view).bounces = YES;
    }
    return NO;
}

- (void)roundedCorners:(CGFloat)cornerRadius rectCorner:(UIRectCorner)rectCorner targetView:(UIView *)targetView {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = targetView.bounds;
    layer.path = path.CGPath;
    targetView.layer.mask = layer;
}

- (void)setSpaceToTop:(CGFloat)spaceToTop {
    _spaceToTop = spaceToTop;
    self.baseView.frame = CGRectMake(self.baseView.frame.origin.x, self.baseView.frame.origin.y, self.baseView.frame.size.width, self.baseView.frame.size.height - spaceToTop);
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}


@end
