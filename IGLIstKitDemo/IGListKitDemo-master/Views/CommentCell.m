//
//  CommentCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation CommentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        [_commentLabel setTextColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.57 alpha:1]];
        [_commentLabel setTextAlignment:NSTextAlignmentLeft];
        [_commentLabel setFont:[UIFont systemFontOfSize:11]];
    }
    return _commentLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    [self.commentLabel setFrame:CGRectInset(bounds, 8.0, 0)];
}

- (NSString *)comment {
    return self.commentLabel.text;
}
- (void)setComment:(NSString *)comment {
    self.commentLabel.text = comment;
}
@end
