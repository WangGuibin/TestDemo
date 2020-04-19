//
//  WMImageBrowerUniteView.m
//  Weimai
//
//  Created by 王贵彬 on 2020/4/19.
//  Copyright © 2020 微脉科技. All rights reserved.
//

#import "WMImageBrowerUniteView.h"

@interface WMImageBrowerUniteView()

@property (nonatomic, strong) WGBImageBrowerModel *model;

@end


@implementation WMImageBrowerUniteView

- (instancetype)initWithModel:(WGBImageBrowerModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.imageView = [[WMImageBrowerUnitImageView alloc] initWithModel: self.model];
    [self addSubview: self.imageView];
    
    //所有图片初始都是靠左约束，关键逻辑是滑动过程中约束靠左或靠右的变化
    //顶部
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    //底部
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    //左边
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    //右边
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self addConstraints:@[topConstraint, bottomConstraint, self.leftConstraint]];
}


@end
