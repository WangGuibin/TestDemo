//
//  DHBounceView.m
//  BounceEffect
//
//  Created by DreamHack on 15-10-15.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import "DHBounceView.h"

@interface DHBounceView ()

@property (nonatomic, strong) CAShapeLayer * maskLayer;
@property (nonatomic, strong) CADisplayLink * displayLink;

@property (nonatomic, strong) UIView * topControlPointView;
@property (nonatomic, strong) UIView * leftControlPointView;
@property (nonatomic, strong) UIView * bottomControlPointView;
@property (nonatomic, strong) UIView * rightControlPointView;

@end

@implementation DHBounceView


- (instancetype)initWithContentsFrame:(CGRect)frame interval:(CGFloat)interval
{
    self = [super init];
    if (self) {
        self.contentsFrame = frame;
        self.interval = interval;
        [self initializeAppearance];
    }
    return self;
}

#pragma mark - callback
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.displayLink.paused) {
        return;
    }
    [self startDisplayLink];
    [self bounceWithAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.clickAction) {
        return;
    }
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.15 initialSpringVelocity:5.5 options:0 animations:^{
        [self positionControlPoints];
    } completion:^(BOOL finished) {
        [self stopDisplayLink];
    }];
    self.clickAction(self);
}

- (void)onDisplayLink
{
    self.maskLayer.path = [self pathForMaskLayer];
}

#pragma mark - private methods

- (void)startDisplayLink
{
    self.displayLink.paused = NO;
}

- (void)stopDisplayLink
{
    self.displayLink.paused = YES;
}

- (CGPathRef)pathForMaskLayer
{
    CGFloat width = CGRectGetWidth(self.contentsFrame);
    CGFloat height = CGRectGetHeight(self.contentsFrame);
    CGPoint topControlPoint = CGPointMake(width/2, [self.topControlPointView.layer.presentationLayer position].y - self.interval);
    CGPoint rightControlPoint = CGPointMake([self.rightControlPointView.layer.presentationLayer position].x - self.interval, height/2);
    CGPoint bottomControlPoint = CGPointMake(width/2, [self.bottomControlPointView.layer.presentationLayer position].y - self.interval);
    CGPoint leftControlPoint = CGPointMake([self.leftControlPointView.layer.presentationLayer position].x - self.interval, height/2);
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addQuadCurveToPoint:CGPointMake(width, 0) controlPoint:topControlPoint];
    [bezierPath addQuadCurveToPoint:CGPointMake(width, height) controlPoint:rightControlPoint];
    [bezierPath addQuadCurveToPoint:CGPointMake(0, height) controlPoint:bottomControlPoint];
    [bezierPath addQuadCurveToPoint:CGPointZero controlPoint:leftControlPoint];
    
    return bezierPath.CGPath;
}

- (void)bounceWithAnimation
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1.5 options:0 animations:^{
        
        self.topControlPointView.frame = CGRectOffset(self.topControlPointView.frame, 0, -self.interval);
        self.leftControlPointView.frame = CGRectOffset(self.leftControlPointView.frame, -self.interval, 0);
        self.bottomControlPointView.frame = CGRectOffset(self.bottomControlPointView.frame, 0, self.interval);
        self.rightControlPointView.frame = CGRectOffset(self.rightControlPointView.frame, self.interval, 0);
        
    } completion:^(BOOL finished) {
        
//        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.15 initialSpringVelocity:5.5 options:0 animations:^{
//            [self positionControlPoints];
//        } completion:^(BOOL finished) {
//            [self stopDisplayLink];
//        }];
    }];
}

/**
 *  通过contentsFrame和interval确定自己的frame
 */
- (void)updateFrame
{
    CGFloat x = self.contentsFrame.origin.x - self.interval;
    CGFloat y = self.contentsFrame.origin.y - self.interval;
    CGFloat width = self.contentsFrame.size.width + 2 * self.interval;
    CGFloat height = self.contentsFrame.size.height + 2 * self.interval;
    self.frame = CGRectMake(x, y, width, height);
    
    _privateContentsFrame = CGRectMake(self.interval, self.interval, CGRectGetWidth(self.contentsFrame), CGRectGetHeight(self.contentsFrame));
    
    self.maskLayer.frame = _privateContentsFrame;
}

- (void)initializeAppearance
{
    for (UIView * view in @[self.topControlPointView, self.leftControlPointView, self.bottomControlPointView, self.rightControlPointView]) {
        
        view.frame = CGRectMake(0, 0, 5, 5);
        [self addSubview:view];
    }
    [self positionControlPoints];
    
    self.layer.mask = self.maskLayer;

}

/**
 *  把四个控制点还原到起始位置（在初始化的时候也要调用，让它们一开始就在起始位置）
 */
- (void)positionControlPoints
{
    self.topControlPointView.center = CGPointMake(CGRectGetMidX(self.bounds), self.interval);
    
    self.leftControlPointView.center = CGPointMake(self.interval, CGRectGetMidY(self.bounds));
    
    self.bottomControlPointView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - self.interval);
    
    self.rightControlPointView.center = CGPointMake(CGRectGetWidth(self.bounds) - self.interval, CGRectGetMidY(self.bounds));
}

#pragma mark - setter
- (void)setContentsFrame:(CGRect)contentsFrame
{
    _contentsFrame = contentsFrame;
    [self updateFrame];
}

- (void)setInterval:(CGFloat)interval
{
    _interval = interval;
    [self updateFrame];
}

#pragma mark - getter
- (UIView *)topControlPointView
{
    if (!_topControlPointView) {
        _topControlPointView = [[UIView alloc] init];
    }
    return _topControlPointView;
}


- (UIView *)leftControlPointView
{
    if (!_leftControlPointView) {
        _leftControlPointView = [[UIView alloc] init];
    }
    return _leftControlPointView;
}

- (UIView *)bottomControlPointView
{
    if (!_bottomControlPointView) {
        _bottomControlPointView = [[UIView alloc] init];
    }
    return _bottomControlPointView;
}

- (UIView *)rightControlPointView
{
    if (!_rightControlPointView) {
        _rightControlPointView = [[UIView alloc] init];
    }
    return _rightControlPointView;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = ({
        
            CAShapeLayer * layer = [CAShapeLayer layer];
            layer.fillColor = [UIColor redColor].CGColor;
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor clearColor].CGColor;
            layer.frame = _privateContentsFrame;
            layer.path = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
            
            layer;
        
        });
    }
    return _maskLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = ({
        
            CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
            displayLink.paused = YES;
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
            displayLink;
        
        });
    }
    return _displayLink;
}





@end
