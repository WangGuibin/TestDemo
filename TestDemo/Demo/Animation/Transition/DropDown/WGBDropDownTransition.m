//
// WGBDropDownTransition.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/12
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
    

#import "WGBDropDownTransition.h"

@implementation WGBDropDownTransition

- (void)setSnapshot:(UIView *)snapshot{
    _snapshot = snapshot;
    if (self.delegate) {
        snapshot.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(dismiss)];
        [snapshot addGestureRecognizer: tap];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.duration? : 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = [transitionContext containerView];
    CGAffineTransform moveDown = CGAffineTransformMakeTranslation(0, container.frame.size.height - 150);//露出一些
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0, -50);
    
    if (self.isPresenting) {
        toView.transform = moveUp;
        self.snapshot = [fromView snapshotViewAfterScreenUpdates:YES];
        [container addSubview: toView];
        [container addSubview: self.snapshot];
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:(UIViewAnimationOptionTransitionNone) animations:^{
        if (self.isPresenting) {
            self.snapshot.transform = moveDown;
            toView.transform = CGAffineTransformIdentity;
        }else{
            self.snapshot.transform = CGAffineTransformIdentity;
            fromView.transform = moveUp;
        }
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        if (!self.isPresenting) {
            [self.snapshot removeFromSuperview];
        }
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresenting = NO;
    return self;
}

@end
