//
// WGBDotLineCell.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/21
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
    

#import "WGBDotLineCell.h"

@interface WGBDotLineCell()

@property (nonatomic,strong) CALayer *topLineLayer;
@property (nonatomic,strong) CALayer *bottomLineLayer;

@end

@implementation WGBDotLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(236, 235, 236);
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(80, 10, 280 , 80)];
        whiteView.backgroundColor = UIColor.whiteColor;
        whiteView.layer.cornerRadius = 5.0;
        [self addSubview: whiteView];

        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(20, whiteView.center.y - 15, 30 , 30)];
        circleView.backgroundColor = [UIColor orangeColor];
        circleView.layer.cornerRadius = 15.0f;
        [self addSubview: circleView];
        
        self.topLineLayer = [CALayer layer];
        self.topLineLayer.frame = CGRectMake(circleView.center.x, CGRectGetMaxY(circleView.frame), 1 , 100-CGRectGetMaxY(circleView.frame));
        self.topLineLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.topLineLayer];
        
        self.bottomLineLayer = [CALayer layer];
        self.bottomLineLayer.frame = CGRectMake(circleView.center.x, 0, 1 , 100-CGRectGetMaxY(circleView.frame));
        self.bottomLineLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.bottomLineLayer];
        
    }
    return self;
}


- (void)isHiddenSomeLineByIndex:(NSInteger)indexRow
                       rowCount:(NSInteger)rowCount{
    if (indexRow == rowCount -1) {
        self.topLineLayer.hidden = YES;
    }else{
        self.topLineLayer.hidden = NO;
    }
    
    if (indexRow == 0) {
        self.bottomLineLayer.hidden = YES;
    }else{
        self.bottomLineLayer.hidden = NO;
    }
}

@end
