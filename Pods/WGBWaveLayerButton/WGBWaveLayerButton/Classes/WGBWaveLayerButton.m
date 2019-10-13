//
//  WGBWaveLayerButton.m
//
//  Created by mac on 2019/9/18.
//  Copyright © 2019年 CoderWGB. All rights reserved.
//

#import "WGBWaveLayerButton.h"

@interface WGBButtonCircleRect : NSObject

@property (nonatomic,assign) CGPoint touchPoint;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat deltaAlpha;

@end

@implementation WGBButtonCircleRect

@end


@interface WGBWaveLayerButton ()

@property(nonatomic,assign) NSInteger loopCount;
@property(nonatomic,strong) NSMutableDictionary *circles;
@property(nonatomic,assign) NSInteger clickCount;

@end

@implementation WGBWaveLayerButton


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.waveLayerColor = [UIColor clearColor];
    
    self.animationDuration = 1;
    self.loopCount = self.animationDuration / 0.02;

    self.circles = [NSMutableDictionary dictionary];
    self.clickCount = 1;
    
    [self addTarget:self action:@selector(touchedDown:event:) forControlEvents:UIControlEventTouchDown];
    return self;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration{
    _animationDuration = animationDuration;
    self.loopCount = animationDuration / 0.02;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat endAngle = M_PI * 2;
    
    for (WGBButtonCircleRect *waveRect in self.circles.allValues) {
        CGContextAddArc(context,
                        waveRect.touchPoint.x,
                        waveRect.touchPoint.y,
                        waveRect.radius * waveRect.deltaAlpha,
                        0,
                        endAngle,
                        NO);
        [[self.waveLayerColor colorWithAlphaComponent:(1 - waveRect.deltaAlpha)] setStroke];
        [[self.waveLayerColor colorWithAlphaComponent:(1 - waveRect.deltaAlpha)] setFill];
        CGContextFillPath(context);
    }
}


- (void)touchedDown:(UIButton *)btn event:(UIEvent *)event{
    
    UITouch *touch = event.allTouches.allObjects.firstObject;
    CGPoint touchePoint = [touch locationInView:btn];
    
    WGBButtonCircleRect *rect = [WGBButtonCircleRect new];
    rect.touchPoint = touchePoint;
    rect.radius = 0.0;
    rect.deltaAlpha = 0.0;
    
    CGFloat maxX = touchePoint.x > (self.frame.size.width - touchePoint.x)? touchePoint.x : (self.frame.size.width-touchePoint.x);
    CGFloat maxY = touchePoint.y > (self.frame.size.width - touchePoint.y)? touchePoint.y : (self.frame.size.height-touchePoint.y);
    rect.radius = maxX > maxY ? maxX : maxY;
    [self.circles setObject: rect forKey:@(self.clickCount).stringValue];

    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01
                                             target:self
                                           selector:@selector(timerFunction:)
                                           userInfo:@{@"click":@(self.clickCount).stringValue}
                                            repeats:YES];
    
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    self.clickCount++;
}

- (void)timerFunction:(NSTimer *)timer{
    [self setNeedsDisplay];

    NSDictionary *userInfo = timer.userInfo;
    NSString *key = userInfo[@"click"];
    WGBButtonCircleRect *rect = self.circles[key];
    if(rect.deltaAlpha <= 1){
        rect.deltaAlpha += (1.0/self.loopCount);
    }else{
        [self.circles removeObjectForKey:key];
        [timer invalidate];
    }
}

@end
