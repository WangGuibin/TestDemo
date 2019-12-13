//
// WGBCommentCell.m
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
    

#import "WGBCommentCell.h"

@interface WGBCommentCell (
                           )
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation WGBCommentCell

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
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.57 alpha:1.0];
    self.commentLabel.textAlignment = NSTextAlignmentLeft;
    self.commentLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.commentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = 8.0;
    CGRect bounds = self.contentView.bounds;
    self.commentLabel.frame = CGRectMake(left, 0, bounds.size.width - left * 2.0, bounds.size.height);
}

- (void)setComment:(NSString *)comment {
    _comment = [comment copy];
    
    self.commentLabel.text = _comment;
}

@end
