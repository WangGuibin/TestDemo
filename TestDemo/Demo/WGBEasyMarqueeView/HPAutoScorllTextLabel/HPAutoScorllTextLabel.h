//
//  HPAutoScorllTextLabel.h
//  DY-ios
//
//  Created by mac on 2019/9/14.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HPTextCycleStyle) {
    HPTextCycleStyleDefault,//当文字长度大于label长度的长度才可以进行滚动
    HPTextCycleStyleAlways //无论文字长短，一直滚动
};

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface HPAutoScorllTextLabel : UIView

@property (nonatomic, assign) HPTextCycleStyle style; //默认HPTextCycleStyleDefault
@property (nonatomic, assign)IBInspectable CGFloat interval; //间隔 默认 70
@property (nonatomic, assign)IBInspectable CGFloat rate;//速率 0~1 默认 0.5

@property (nonatomic, copy)IBInspectable NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong)IBInspectable UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)start;  
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
