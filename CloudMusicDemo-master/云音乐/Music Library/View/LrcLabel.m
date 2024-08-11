//
//  LrcLabel.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/27.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LrcLabel.h"

@implementation LrcLabel

- (void)setPross:(CGFloat)pross{
    _pross = pross;
    //重绘 会调用自动调用drawRect方法，
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //获取需要画的区域
    CGRect rec = CGRectMake(0, 0, self.bounds.size.width * self.pross, self.bounds.size.height);
    //设置颜色
    [[UIColor greenColor] set];
    //添加区域开始画图
    UIRectFillUsingBlendMode(rec, kCGBlendModeSourceIn);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
