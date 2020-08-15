//
// WGBFlipTransition.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/15
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
    

#import "WGBFlipTransition.h"

@implementation WGBFlipTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flipDirectionType = WGBFlipFromDirectionTypeFromLeft;
        self.transitionDuration = 1.0f;
    }
    return self;
}


- (UIViewAnimationOptions)getAnimationOptions{
    if (self.flipDirectionType == WGBFlipFromDirectionTypeFromLeft) {
        return UIViewAnimationOptionTransitionFlipFromLeft;
    }
    if (self.flipDirectionType == WGBFlipFromDirectionTypeFromRight) {
        return UIViewAnimationOptionTransitionFlipFromRight;
    }
    if (self.flipDirectionType == WGBFlipFromDirectionTypeFromTop) {
        return UIViewAnimationOptionTransitionFlipFromTop;
    }
    if (self.flipDirectionType == WGBFlipFromDirectionTypeFromBottom) {
        return UIViewAnimationOptionTransitionFlipFromBottom;
    }
    return UIViewAnimationOptionTransitionFlipFromLeft;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [UIView transitionFromView:fromVC.view toView:toVC.view duration:[self transitionDuration:transitionContext] options:[self getAnimationOptions] completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
//        self.transition.flipDirectionType = WGBFlipFromDirectionTypeFromLeft;
        self.flipDirectionType = arc4random()%4;
        return self;
    }else if (operation == UINavigationControllerOperationPop){
//        self.transition.flipDirectionType = WGBFlipFromDirectionTypeFromRight;
        self.flipDirectionType = arc4random()%4;
        return self;
    }
    return nil;
}


@end
