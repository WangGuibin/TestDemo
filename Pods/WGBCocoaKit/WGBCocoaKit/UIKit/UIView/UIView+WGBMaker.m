//
//  UIView+WGBMaker.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "UIView+WGBMaker.h"

@implementation UIView (WGBMaker)

+ (WGBUIViewMaker *)make{
    return [WGBUIViewMaker new];
}

@end

@implementation UILabel (WGBMaker)

+ (WGBUILabelMaker *)make{
    return [WGBUILabelMaker new];
}

@end


@implementation UIButton (WGBMaker)

+ (WGBUIButtonMaker *)make{
    return [WGBUIButtonMaker new];
}

@end


@implementation UIImageView (WGBMaker)

+ (WGBUIImageViewMaker *)make{
    return [WGBUIImageViewMaker new];
}

@end
