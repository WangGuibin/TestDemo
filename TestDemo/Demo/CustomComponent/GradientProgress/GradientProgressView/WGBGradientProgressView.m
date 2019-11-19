//
//  WGBGradientProgressView.m
//  TestDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBGradientProgressView.h"

@interface WGBGradientProgressView()

@property (nonatomic, strong) CAGradientLayer *gradLayer;
@property (nonatomic, strong) CALayer *mask;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,assign) BOOL flag;

@end

@implementation WGBGradientProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.flag = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.timer) {
        // 销毁定时器
        [self stopTimer];
    }
}

- (void)setProgress:(CGFloat)progress{
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    _progress = progress;
    
    if (!self.flag) {//初始化
        [self initBottomLayer];
        [self setupTimer];
        [self startTimer];
    }
    
    CGFloat maskWidth = progress * self.frame.size.width;
    self.mask.frame = CGRectMake(0, 0, maskWidth, self.frame.size.height);
}


- (void)initBottomLayer{
    if (self.gradLayer == nil) {
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = self.bounds;
    }
    self.gradLayer.startPoint = CGPointMake(0, 0.5);
    self.gradLayer.endPoint = CGPointMake(1, 0.5);
    
    //create colors, important section
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger deg = 0; deg <= 360; deg += 5) {
        
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * deg / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    [self.gradLayer setColors:[NSArray arrayWithArray:colors]];
    self.mask = [CALayer layer];
    CGRect rect = self.frame;
    [self.mask setFrame:CGRectMake(self.gradLayer.frame.origin.x, self.gradLayer.frame.origin.y,
                                   self.progress * rect.size.width, rect.size.height)];
    self.mask.borderColor = [[UIColor blueColor] CGColor];
    self.mask.borderWidth = rect.size.height/2.0f;
    [self.gradLayer setMask:self.mask];
    [self.layer addSublayer:self.gradLayer];
}

- (void)setupTimer{
    CGFloat interval = 0.03;
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:interval target:self
                                           selector:@selector(timerFunc)
                                           userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)startTimer{
    if (self.flag) {
        return ;
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer setFireDate:[NSDate date]];
    self.flag = YES;
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.flag = NO;
}

- (void)timerFunc{
    CAGradientLayer *gradLayer = self.gradLayer;
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:[gradLayer colors]];
    UIColor *lastColor = [copyArray lastObject];
    [copyArray removeLastObject];
    if (lastColor) {
        [copyArray insertObject:lastColor atIndex:0];
    }
    [self.gradLayer setColors:copyArray];
}

@end
