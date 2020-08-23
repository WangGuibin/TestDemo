//
// WGBWeixinVideoTransition.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/22
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
    

#import "WGBWeixinVideoTransition.h"
#import "WGBWeixinDemoTestViewController.h"
#import "WGBWeixinDemoTestToViewController.h"

@implementation WGBWeixinVideoTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.transitionType) {
        case WGBWeiXinTransitionTypePush:
        {
        [self pushAnimation:transitionContext];
        }
            break;
        case WGBWeiXinTransitionTypePop:
        {
        [self popAnimation:transitionContext];
        }
            break;
        case WGBWeiXinTransitionTypePresent:
        {
        [transitionContext completeTransition:YES];
        }
            break;
        case WGBWeiXinTransitionTypeDismiss:
        {
        [transitionContext completeTransition:YES];
        }
            break;
        default:
            break;
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<WGBWeixinVideoTransitionDelegate> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController<WGBWeixinVideoTransitionDelegate> *fromVC;
    id tempVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([tempVC isKindOfClass:[UINavigationController class]]) {
        fromVC = ((UINavigationController *)tempVC).viewControllers.lastObject;
    }else if([tempVC isKindOfClass:[UIViewController class]]){
        fromVC = tempVC;
    }

    UIView * fromContenView = [fromVC wgb_TransitionContentView];
    UIView *toContentView = [toVC wgb_TransitionContentView];
    UIView *containerView = [transitionContext containerView];
    UIView *snapshotView = [fromContenView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [fromContenView convertRect:fromContenView.bounds toView:containerView];

    fromContenView.hidden = YES;
    toContentView.hidden = YES;
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshotView];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0 usingSpringWithDamping:0.75  initialSpringVelocity:1.0 options:0 animations:^{
        snapshotView.frame = [toContentView  convertRect:toContentView.bounds toView:containerView];
    } completion:^(BOOL finished) {
        toContentView.hidden = NO;
        [snapshotView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController<WGBWeixinVideoTransitionDelegate> *toVC;
    UIViewController<WGBWeixinVideoTransitionDelegate> * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    id tempVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([tempVC isKindOfClass:[UINavigationController class]]) {
        toVC = ((UINavigationController *)tempVC).viewControllers.lastObject;
    }else if([tempVC isKindOfClass:[UIViewController class]]){
        toVC = tempVC;
    }

    UIView *toContentView = [toVC wgb_TransitionContentView];
    UIView *fromContentView = [fromVC wgb_TransitionContentView];
    UIView *containerView = [transitionContext containerView];
    
    UIView *snapshotView = [fromContentView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [fromContentView convertRect:fromContentView.bounds toView:containerView];
    fromContentView.hidden = YES;
    [containerView addSubview:toVC.view];
    
    //背景过渡视图 黑色背景才需要加蒙版渐变
//    UIView * bgView = [[UIView alloc] initWithFrame:fromVC.view.bounds];
//    bgView.backgroundColor = [UIColor blackColor];
//    [containerView addSubview:bgView];
    
    [containerView addSubview:snapshotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.frame = [toContentView convertRect:toContentView.bounds toView:containerView];
//        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            fromContentView.hidden = NO;
        }else{
            toContentView.hidden = NO;
        }
        [snapshotView removeFromSuperview];
//        [bgView removeFromSuperview];
    }];

}

@end
