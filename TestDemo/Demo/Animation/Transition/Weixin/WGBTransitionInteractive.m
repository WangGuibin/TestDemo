//
// WGBTransitionInteractive.m
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
    

#import "WGBTransitionInteractive.h"

@implementation WGBTransitionInteractive


//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.viewController = viewController;
    [viewController.view addGestureRecognizer:pan];
}

//手势过渡处理
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGPoint  translation = [panGesture translationInView:panGesture.view];
    CGFloat percentComplete = 0.0;
    //左右滑动的百分比
    percentComplete = translation.x / (_viewController.view.frame.size.width);
    percentComplete = fabs(percentComplete);
    NSLog(@"%f",percentComplete);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            [_viewController.navigationController  popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置转场过程动画进行的百分比，然后系统会根据百分比自动布局动画控件，不用我们控制了
            [self updateInteractiveTransition:percentComplete];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            _isInteractive = NO;
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作，转场失败
            if (percentComplete > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}



@end
