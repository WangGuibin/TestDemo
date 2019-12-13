//
//  CenterLabelCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "CenterLabelCell.h"

@interface CenterLabelCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation CenterLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:[UIColor whiteColor]];
        [_label setFont:[UIFont boldSystemFontOfSize:18]];
    }
    return _label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label setFrame:self.contentView.bounds];
}

- (NSString *)text {
    return _label.text;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}
@end
