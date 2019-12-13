//
//  MonthTitleCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "MonthTitleCell.h"
#import "MonthTitleViewModel.h"

@interface MonthTitleCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MonthTitleCell

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:[UIColor colorWithWhite:0.7 alpha:1]];
        [_label setFont:[UIFont boldSystemFontOfSize:13]];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label setFrame:self.contentView.bounds];
}

- (void)bindViewModel:(id)viewModel {
    if ([viewModel isKindOfClass:[MonthTitleViewModel class]]) {
        self.label.text = ((MonthTitleViewModel *)viewModel).name.uppercaseString;
    }
}
@end
