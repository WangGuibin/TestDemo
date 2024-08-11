//
//  CALayer+Aimate.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/24.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "CALayer+Aimate.h"

@implementation CALayer (Aimate)
-(void)pauseAnimate{
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pauseTime;
}

- (void)resumeAnimate{
    CFTimeInterval pauseTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.beginTime = timeSincePause;
}
@end
