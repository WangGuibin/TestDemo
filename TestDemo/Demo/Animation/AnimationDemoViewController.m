//
// AnimationDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/18
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
    

#import "AnimationDemoViewController.h"
#import "GlowingAnimationDemoViewController.h"
#import "BoomBoomBoomAnimationDemoViewController.h"
#import "WGBSpringAnimationDemoViewController.h"
#import "WGBLikeAnimationDemoViewController.h"
#import "WGBTransitionDemoListViewController.h" 
#import "WGBDrawTextDemoViewController.h"
#import "WGBEmitterDemoViewController.h"
#import "WGBFlowButtonDemoViewController.h"
#import "WGBStrokeEndDemoViewController.h"
#import "WGBGoodsCartDemoViewController.h"
#import "WGBBounceEffectButtonDemoVC.h"

@interface AnimationDemoViewController ()

@end

@implementation AnimationDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBTransitionDemoListViewController class],
        [GlowingAnimationDemoViewController class],
        [BoomBoomBoomAnimationDemoViewController class],
        [WGBSpringAnimationDemoViewController class],
        [WGBLikeAnimationDemoViewController class],
        [WGBDrawTextDemoViewController class],
        [WGBEmitterDemoViewController class],
        [WGBFlowButtonDemoViewController class],
        [WGBStrokeEndDemoViewController class],
        [WGBGoodsCartDemoViewController class],
        [WGBBounceEffectButtonDemoVC class]
     ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"转场动画",
        @"发光放大缩小动画",
        @"炸裂动画",
        @"Spring弹性动画",
        @"点赞动画",
        @"绘制文字动画",
        @"粒子动画效果",
        @"按钮流光动画",
        @"路径动画",
        @"仿购物车动画",
        @"Q弹的按钮"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
 
#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
 
#pragma mark =====缩放-=============
-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}
 
#pragma mark =====组合动画-=============
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
 
#pragma mark =====路径动画-=============
-(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;
    return animation;
}
 
#pragma mark ====旋转动画======
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
 
    return animation;
}

@end
