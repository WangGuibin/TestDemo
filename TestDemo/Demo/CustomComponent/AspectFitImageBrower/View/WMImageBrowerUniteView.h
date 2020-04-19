//
//  WMImageBrowerUniteView.h
//  Weimai
//
//  Created by 王贵彬 on 2020/4/19.
//  Copyright © 2020 微脉科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMImageBrowerUnitImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMImageBrowerUniteView : UIView

@property (nonatomic, strong) WMImageBrowerUnitImageView *imageView;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;

- (instancetype)initWithModel:(WGBImageBrowerModel *)model;

@end

NS_ASSUME_NONNULL_END
