//
//  DetailLabelCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DetailLabelCell.h"

@interface DetailLabelCell ()

@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation DetailLabelCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *view = [[UILabel alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTextAlignment:NSTextAlignmentLeft];
        [view setFont:[UIFont systemFontOfSize:17]];
        [view setTextColor:[UIColor darkTextColor]];
        _titleLabel = view;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *view = [[UILabel alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTextAlignment:NSTextAlignmentRight];
        [view setFont:[UIFont systemFontOfSize:17]];
        [view setTextColor:[UIColor lightGrayColor]];
        _detailLabel = view;
    }
    return _detailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        _padding = 15.0;
    }
    return self;
}

- (NSString *)title {
    return _titleLabel.text;
}
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)detail {
    return _detailLabel.text;
}
- (void)setDetail:(NSString *)detail {
    _detailLabel.text = detail;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = CGRectInset(self.contentView.bounds, _padding, 0);
    _titleLabel.frame = frame;
    _detailLabel.frame = frame;
}
@end
