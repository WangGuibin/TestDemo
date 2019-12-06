//
// WGBPushPopSimpleTransition.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/6
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
    

#import "WGBPushPopSimpleTransition.h"

@implementation WGBPushPopSimpleTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    
    //此处判断是push，还是pop 操作
    // push fromView是self.view ToView是要展示的View  pop 也是一样 from -> To 转场嘛
    BOOL isPush = ([toViewController.navigationController.viewControllers indexOfObject:toViewController] > [fromViewController.navigationController.viewControllers indexOfObject:fromViewController]);
    
    //设置初始frame
    if (isPush) {
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        toView.frame = CGRectMake(0, -KHIGHT, KWIDTH, KHIGHT);
    }else{
        [containerView addSubview:toView];
        [containerView addSubview:fromView];//pop
        fromView.frame = CGRectMake(0, 0, KWIDTH, KHIGHT);
    }
    //因为pop toView和fromView角色转换 但是视图层级以及显示的先后顺序要符合转场的需求
   //  push 是把toView盖在fromView上面做动画   pop则是把fromView盖在上面 做动画完后移除
    
    //此动画： 从天而降 一降再降
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:(UIViewAnimationOptionShowHideTransitionViews) animations:^{
        if (isPush) {
            toView.frame = CGRectMake(0, 0, KWIDTH, KHIGHT);
        }else{
            fromView.frame = CGRectMake(0, KHIGHT, KWIDTH, KHIGHT);
        }
    } completion:^(BOOL finished) {
        //是否被取消
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //若没有被取消 则设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}


@end
