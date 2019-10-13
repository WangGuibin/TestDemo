//
//  WGBRepairedOrientationLabel.h
//  WGBRepairedOrientationLabel
//
//  Created by mac on 2019/9/16.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>
//对齐方式枚举 默认是系统的样式
typedef NS_ENUM(NSUInteger, WGBRepairedTextAlignType) {
    WGBRepairedTextAlignTypeTop = 0, //上对齐
    WGBRepairedTextAlignTypeLeft, //左对齐
    WGBRepairedTextAlignTypeBottom, //底部对齐
    WGBRepairedTextAlignTypeRight,//右对齐
    
    WGBRepairedTextAlignTypeHorizontalVerticalCenter,//水平垂直居中对齐
    
    WGBRepairedTextAlignTypeHorizontalTopCenter,//顶部水平居中对齐
    WGBRepairedTextAlignTypeHorizontalBottomCenter,//底部水平居中对齐
    
    WGBRepairedTextAlignTypeVerticalLeftCenter,//左边垂直居中对齐
    WGBRepairedTextAlignTypeVerticalRightCenter, //右边垂直对齐
    
    WGBRepairedTextAlignTypeLeftTop,//左上对齐
    WGBRepairedTextAlignTypeLeftBottom,//左下对齐
    WGBRepairedTextAlignTypeRightTop,//右上对齐
    WGBRepairedTextAlignTypeRightBottom //右下对齐
};

NS_ASSUME_NONNULL_BEGIN

@interface WGBRepairedOrientationLabel : UILabel

@property (nonatomic,assign) WGBRepairedTextAlignType alignType;

@end

NS_ASSUME_NONNULL_END
