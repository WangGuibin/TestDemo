//
// WGBInteractionDrawerTransition.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/9/6
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
    

#import "WGBInteractionDrawerTransition.h"

@implementation WGBInteractionDrawerTransition

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPush) {
        [self beginTransitionWithTransitionContext:transitionContext];
    } else {
        [self endTransitionWithTransitionContext:transitionContext];
    }
}


- (void)beginTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.frame = transitionContext.containerView.bounds;
    [transitionContext.containerView addSubview:toView];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    toView.x = toView.width;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.x = 0;
        fromView.transform = CGAffineTransformMakeScale(0.93, 0.93);
    } completion:^(BOOL finished) {
        toView.x = 0;
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)endTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    toView.frame = transitionContext.containerView.bounds;
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView bringSubviewToFront:fromView];
    
    toView.transform = CGAffineTransformMakeScale(0.93, 0.93);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.x = fromView.width;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.frame = transitionContext.containerView.bounds;
        toView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
