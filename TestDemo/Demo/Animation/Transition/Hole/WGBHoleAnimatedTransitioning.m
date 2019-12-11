//
// WGBHoleAnimatedTransitioning.m
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
    

#import "WGBHoleAnimatedTransitioning.h"

static const CGFloat kRatio = 1.5f;

@interface WGBHoleAnimatedTransitioning()<CAAnimationDelegate>

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation WGBHoleAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containView = transitionContext.containerView;
    NSLog(@"%@ - %@",toViewController,fromViewController);
//      WGBCustomNavgationViewController  ->  WGBTestCATransitionDemoViewController

//    [containView addSubview:toViewController.view];
//    [containView addSubview:fromViewController.view];
    if (fromViewController.modalPresentationStyle == UIModalPresentationFullScreen) {
        [containView addSubview:toViewController.view];
        [containView addSubview:fromViewController.view];
    }else{
        [containView addSubview:fromViewController.view];
        [containView addSubview:toViewController.view];
    }
    
    UIView * endView = [UIView new];
    endView.frame = self.entranceFrame;
    UIBezierPath * endPath = [UIBezierPath bezierPathWithOvalInRect:endView.frame];
    
    UIView * startView = [UIView new];
    startView.center = endView.center;
    startView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height * kRatio, [UIScreen mainScreen].bounds.size.height * kRatio);
    UIBezierPath * startpath = [UIBezierPath bezierPathWithOvalInRect:startView.frame];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    fromViewController.view.layer.mask = maskLayer;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id )(startpath.CGPath);
    animation.toValue = (__bridge id )(endPath.CGPath);
    animation.duration = [self transitionDuration:self.transitionContext];
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    self.transitionContext = nil;
}



@end
