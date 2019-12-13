//
//  PhotoCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()
@property (nonatomic, strong) UIView *view;
@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.view];
    }
    return self;
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor colorWithRed:4/255.0 green:170/255.0 blue:166/255.0 alpha:1.0];
    }
    return _view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.contentView.frame;
}
@end
