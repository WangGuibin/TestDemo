//
// WGBInteractionOpenDoorTransition.m
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
    

#import "WGBInteractionOpenDoorTransition.h"

@implementation WGBInteractionOpenDoorTransition

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPush) {
        [self pushAnimation:transitionContext];
    } else {
        [self popAnimation:transitionContext];
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //左侧动画视图
    UIView *leftFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:leftFromView];
    //右侧动画视图
    UIView *rightFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    rightFromView.frame = CGRectMake(- fromView.frame.size.width/2, 0, fromView.frame.size.width, fromView.frame.size.height);
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightFromView];
    
    [containerView addSubview:toView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    fromView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         leftView.frame = CGRectMake(-fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                         rightView.frame = CGRectMake(fromView.frame.size.width, 0, fromView.frame.size.width/2, fromView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         fromView.hidden = NO;
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //左侧动画视图
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:toView];
    
    //右侧动画视图
    // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *rightToView = [toView snapshotViewAfterScreenUpdates:YES];
    rightToView.frame = CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width, toView.frame.size.height);
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(toView.frame.size.width, 0, toView.frame.size.width/2, toView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightToView];
    
    //加入动画视图
    [containerView addSubview:fromView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         leftView.frame = CGRectMake(0, 0, toView.frame.size.width/2, toView.frame.size.height);
                         rightView.frame = CGRectMake(toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         if([transitionContext transitionWasCancelled]){
                             //手势取消
                         }else{
                             //手势完成
                             [containerView addSubview:toView];
                         }
                         
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         toView.hidden = NO;
                         
                     }];
}


@end
