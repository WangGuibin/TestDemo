//
// WGBUserInfoCell.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/13
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
    

#import "WGBUserInfoCell.h"

@interface WGBUserInfoCell ()
@property (nonatomic, strong) UIView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation WGBUserInfoCell

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.avatarView = [[UIView alloc] init];
    self.avatarView.backgroundColor = [UIColor colorWithRed:210/255.0 green:65/255.0 blue:64/255.0 alpha:1.0];
    [self.contentView addSubview:self.avatarView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.textColor = [UIColor darkTextColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    
    CGFloat avatarViewWidth = 25.0;
    CGFloat avatarTopSpace = (CGRectGetHeight(bounds) - avatarViewWidth) / 2.0;
    CGFloat avatarLeftSpace = 8.0;
    self.avatarView.frame = CGRectMake(avatarLeftSpace, avatarTopSpace, avatarViewWidth, avatarViewWidth);
    self.avatarView.layer.cornerRadius = MIN(CGRectGetHeight(self.avatarView.frame), CGRectGetWidth(self.avatarView.frame)) / 2.0;
    self.avatarView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 8.0, CGRectGetMinY(self.avatarView.frame), CGRectGetWidth(bounds) - CGRectGetMaxX(self.avatarView.frame) - 8.0 * 2, CGRectGetHeight(self.avatarView.frame));
}

- (void)setName:(NSString *)name {
    _name = [name copy];
    
    self.nameLabel.text = _name;
}

@end
