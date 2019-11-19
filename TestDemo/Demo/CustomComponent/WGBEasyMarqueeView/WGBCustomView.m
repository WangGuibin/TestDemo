//
//  WGBCustomView.m
//  WGBEasyMarqueeView_Example
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 Wangguibin. All rights reserved.
//

#import "WGBCustomView.h"

@interface WGBCustomView()

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UISwitch *sw;

@end

@implementation WGBCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{
    [self testView];
    [self sw];
    self.backgroundColor = [UIColor orangeColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.testView.frame = CGRectMake(0, 0, 300 , 50);
    self.sw.frame = CGRectMake(CGRectGetMaxX(self.testView.frame), 0, 51 , 31);
}



- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectZero];
        _testView.backgroundColor = [UIColor redColor];
        [self addSubview: _testView];
    }
    return _testView;
}


- (UISwitch *)sw {
    if (!_sw) {
        _sw = [[UISwitch alloc] initWithFrame:CGRectZero];
        _sw.on = YES;
        [self addSubview: _sw];
    }
    return _sw;
}

@end
