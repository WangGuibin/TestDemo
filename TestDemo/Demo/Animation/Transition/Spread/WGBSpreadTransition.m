//
// WGBSpreadTransition.m
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
    

#import "WGBSpreadTransition.h"

@interface WGBSpreadTransition ()<CAAnimationDelegate>

@property (nonatomic, assign) WGBCircleSpreadTransitionType type;

@end

@implementation WGBSpreadTransition

+ (instancetype)transitionWithTransitionType:(WGBCircleSpreadTransitionType)type
{
    return [[WGBSpreadTransition alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(WGBCircleSpreadTransitionType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDuration)]) {
        return [self.delegate animationDuration];
    }
    return  0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type) {
        case WGBCircleSpreadTransitionTypePresent:
            [self doPresentAnimation:transitionContext];
            break;
        case WGBCircleSpreadTransitionTypeDismiss:
            [self doDismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

- (void)doPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UINavigationController *fromNaviVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<WGBSpreadTransitionProtocol> *fromVC = [fromNaviVC.viewControllers lastObject];
    UIViewController<WGBSpreadTransitionProtocol> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    CGRect finalFrameForToVC = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame =  finalFrameForToVC;
    [containerView addSubview:toVC.view];
    
    //以点击的点画圆
    CGPoint clickedPoint = fromVC.startPoint;
    CGRect rect = CGRectMake(clickedPoint.x - 3, clickedPoint.y - 3, 6, 6);
    //圆的半径最大也就是 利用三角函数,勾股定理,已知宽高求斜边长度 这里斜边就是半径 r = √(a²+b²)
    CGFloat cornerRadius = sqrt(pow([UIScreen mainScreen].bounds.size.width,2) + pow([UIScreen mainScreen].bounds.size.height,2));
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - cornerRadius, clickedPoint.y - cornerRadius, cornerRadius*2, cornerRadius*2) cornerRadius:cornerRadius];
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3];
    //把layer的path设置end状态的path，这也是动画结束时候的状态
    layer.path = endPath.CGPath;
    toVC.view.layer.mask = layer;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleAnimation.fromValue = (__bridge id)(path.CGPath);
    circleAnimation.toValue = (__bridge id)(endPath.CGPath);
    circleAnimation.duration = [self transitionDuration:transitionContext];
    circleAnimation.delegate = self;
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circleAnimation setValue:transitionContext forKey:@"transitionContext"];
    [layer addAnimation:circleAnimation forKey:@"circle"];
}

- (void)doDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<WGBSpreadTransitionProtocol> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGPoint clickedPoint = fromVC.startPoint;
    //圆的半径最大也就是 利用三角函数,勾股定理,已知宽高求斜边长度 这里斜边就是半径 r = √(a²+b²)
    CGFloat cornerRadius = sqrt(pow([UIScreen mainScreen].bounds.size.width,2) + pow([UIScreen mainScreen].bounds.size.height,2));
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - cornerRadius, clickedPoint.y - cornerRadius, cornerRadius*2, cornerRadius*2) cornerRadius:cornerRadius];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedPoint.x - 3, clickedPoint.y - 3, 6, 6) cornerRadius:3];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = endPath.CGPath;
    fromVC.view.layer.mask = layer;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleAnimation.delegate = self;
    circleAnimation.fromValue = (__bridge id)(startPath.CGPath);
    circleAnimation.toValue = (__bridge id)(endPath.CGPath);
    circleAnimation.duration = [self transitionDuration:transitionContext];
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [circleAnimation setValue:transitionContext forKey:@"transitionContext"];
    [layer addAnimation:circleAnimation forKey:@"circleDismiss"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch (self.type) {
        case WGBCircleSpreadTransitionTypePresent:
        {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            [transitionContext viewControllerForKey:UITransitionContextToViewKey].view.layer.mask = nil;
        }
            break;
        case WGBCircleSpreadTransitionTypeDismiss:
        {
        
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"]; 
            [transitionContext completeTransition:YES];
        }
            break;
        default:
            break;
    }
    
}



@end
