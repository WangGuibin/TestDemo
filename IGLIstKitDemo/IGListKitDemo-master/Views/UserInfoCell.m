//
//  UserInfoCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()

@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation UserInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (UIView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIView alloc] init];
        [_avatarView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:65/255.0 blue:64/255.0 alpha:1.0]];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor darkTextColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    
    CGFloat avatarViewWidth = 25.0;
    CGFloat avatarTopSpace = (CGRectGetHeight(bounds) - avatarViewWidth)/2.0;
    CGFloat avatarLeftSpace = 8.0;
    [self.avatarView setFrame:CGRectMake(avatarLeftSpace, avatarTopSpace, avatarViewWidth, avatarViewWidth)];
    [self.avatarView.layer setCornerRadius:MIN(CGRectGetHeight(self.avatarView.frame), CGRectGetWidth(self.avatarView.frame) / 2.0)];
    [self.avatarView.layer setMasksToBounds:YES];
    
    [self.nameLabel setFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 8.0, CGRectGetMinY(self.avatarView.frame), CGRectGetWidth(bounds) - CGRectGetMaxX(self.avatarView.frame) - 8.0 * 2, CGRectGetHeight(self.avatarView.frame))];
}

- (NSString *)name {
    return self.nameLabel.text;
}
- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}
@end
