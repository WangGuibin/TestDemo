//
//  UIView+WGBMaker.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGBUIViewMaker.h"

@class WGBUILabelMaker;

@interface UIView (WGBMaker)
+ (WGBUIViewMaker *)make;
@end

@interface UILabel (WGBMaker)
+ (WGBUILabelMaker *)make;
@end


@interface UIButton (WGBMaker)
+ (WGBUIButtonMaker *)make;
@end


@interface UIImageView (WGBMaker)

+ (WGBUIImageViewMaker *)make;

@end
