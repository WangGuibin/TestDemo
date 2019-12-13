//
//  SpinnerCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SpinnerCell.h"

@interface SpinnerCell ()

@end

@implementation SpinnerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_activityIndicator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    
    [self.activityIndicator setCenter:CGPointMake(bounds.size.width/2, bounds.size.height/2)];
}
@end
