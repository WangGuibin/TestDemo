//
//  ProgressBar.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    
    rect.origin.x=rect.origin.x-10;
    
    rect.size.width=rect.size.width+20;
    
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
