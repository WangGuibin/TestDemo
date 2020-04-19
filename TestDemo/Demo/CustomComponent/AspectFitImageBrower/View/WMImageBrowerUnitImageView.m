//
//  WMImageBrowerUnitImageView.m
//  Weimai
//
//  Created by 王贵彬 on 2020/4/19.
//  Copyright © 2020 微脉科技. All rights reserved.
//

#import "WMImageBrowerUnitImageView.h"

@interface WMImageBrowerUnitImageView ()

@property (nonatomic, strong) WGBImageBrowerModel *model;

@end


@implementation WMImageBrowerUnitImageView

- (instancetype)initWithModel:(WGBImageBrowerModel *)model{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor]; //或者替换为占位图
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.model = model;
    }
    return self;
}

- (void)setModel:(WGBImageBrowerModel *)model {
    _model = model;
    //自身宽高比约束
    NSLayoutConstraint *aseptConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:model.width / model.height constant:0];
    [self addConstraint:aseptConstraint];
}

@end
