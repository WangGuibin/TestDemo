//
// WGBInteractionMotionTransition.m
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
    

#import "WGBInteractionMotionTransition.h"

@implementation WGBInteractionMotionTransition

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPush) {
        [self beginTransitionWithTransitionContext:transitionContext];
    } else {
        [self endTransitionWithTransitionContext:transitionContext];
    }
}

- (void)beginTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <WGBInteractionMotionTransitionDelegate>*fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController <WGBInteractionMotionTransitionDelegate>*toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    UIView *containerView = [transitionContext containerView];
    toView.frame = containerView.bounds;
    [containerView addSubview:toVC.view];
    
    if (!fromVC || !toVC || ![self responseToSel:@[fromVC,toVC]]) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    UIView *sourceView = [fromVC wgb_animationView];
    UIView *destinationView = [toVC wgb_animationView];
    if (!sourceView || !destinationView) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    UIColor *containerViewColor = containerView.backgroundColor;
    containerView.backgroundColor = [UIColor whiteColor];
    
    CGPoint sourcePoint = [sourceView convertPoint:CGPointZero toView:nil];
    CGPoint destinationPoint = [destinationView convertPoint:CGPointZero toView:nil];
    
    UIView *snapShot = [sourceView snapshotViewAfterScreenUpdates:NO];
    [containerView addSubview:snapShot];
    snapShot.origin = sourcePoint;
    
    CGFloat heightScale = destinationView.height / sourceView.height;
    CGFloat widthScale = destinationView.width / sourceView.width;
    
    toView.hidden = YES;
    CGRect originFrame = fromView.frame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShot.transform =  CGAffineTransformMakeScale(widthScale,heightScale);
        snapShot.origin = destinationPoint;
        fromView.alpha = 0;
        fromView.transform = snapShot.transform;
        fromView.origin = CGPointMake((destinationPoint.x - sourcePoint.x) * widthScale, (destinationPoint.y - sourcePoint.y)  *heightScale);
    } completion:^(BOOL finished) {
        containerView.backgroundColor = containerViewColor;
        [snapShot removeFromSuperview];
        toView.hidden = NO;
        fromView.alpha = 1;
        fromView.transform = CGAffineTransformIdentity;
        fromView.frame = originFrame;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)endTransitionWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <WGBInteractionMotionTransitionDelegate>*fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController <WGBInteractionMotionTransitionDelegate>*toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    UIView *containerView = [transitionContext containerView];
    toView.frame = containerView.bounds;
    [containerView addSubview:toView];
    
    if (!fromVC || !toVC || ![self responseToSel:@[fromVC,toVC]]) {
        [transitionContext completeTransition:YES];
        return;
    }
    
    UIView *sourceView = [fromVC wgb_animationView];
    UIView *destinationView = [toVC wgb_animationView];
    if (!sourceView || !destinationView) {
        [transitionContext completeTransition:YES];
        return;
    }

    UIColor *containerViewColor = containerView.backgroundColor;
    containerView.backgroundColor = [UIColor whiteColor];
    
    CGPoint sourcePoint = [sourceView convertPoint:CGPointZero toView:nil];
    CGPoint destinationPoint = [destinationView convertPoint:CGPointZero toView:nil];

    UIView *snapShot = [sourceView snapshotViewAfterScreenUpdates:NO];
    snapShot.origin = sourcePoint;
    [containerView addSubview:snapShot];
    
    CGFloat heightScale = destinationView.height / sourceView.height;
    CGFloat widthScale = destinationView.width / sourceView.width;
    
    CGRect originFrame = toView.frame;
    CGFloat originHeightScale = sourceView.height / destinationView.height;
    CGFloat originWidthScale = sourceView.width / destinationView.width;
    
    toView.transform = CGAffineTransformMakeScale(originWidthScale,originHeightScale);
    toView.origin = CGPointMake((sourcePoint.x - destinationPoint.x) * originWidthScale, (sourcePoint.y - destinationPoint.y) * originHeightScale);
    
    toView.alpha = 0;
    fromView.hidden = YES;
    destinationView.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShot.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        snapShot.origin = destinationPoint;
        toView.alpha = 1.0;
        toView.transform = CGAffineTransformIdentity;
        toView.frame = originFrame;
    } completion:^(BOOL finished) {
        containerView.backgroundColor = containerViewColor;
        fromView.hidden = NO;
        destinationView.hidden = NO;
        [snapShot removeFromSuperview];
        toView.transform = CGAffineTransformIdentity;
        toView.frame = originFrame;
        toView.alpha = 1;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

- (BOOL)responseToSel:(NSArray <UIViewController <WGBInteractionMotionTransitionDelegate>*>*)array {
    if (!array.count) {
        return NO;
    }
    for (UIViewController *vc in array) {
        if (![vc respondsToSelector:@selector(wgb_animationView)]) {
            return NO;
        }
    }
    return YES;
}

@end
