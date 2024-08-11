//
//  DHBounceView.h
//  BounceEffect
//
//  Created by DreamHack on 15-10-15.
//  Copyright (c) 2015年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHBounceView;

typedef void(^DHBounceViewDidClickAction)(DHBounceView * bounceView);

@interface DHBounceView : UIView

/**
 *  视图内容的frame，center和实际的center一样，宽高分别比实际的宽高少2倍interval，这个和实际frame的间隔用来缓冲弹性效果
 */
@property (nonatomic, assign) CGRect contentsFrame;

/**
 *  弹性缓冲的距离，也就是contents边界和实际frame边界的距离
 */
@property (nonatomic, assign) CGFloat interval;

/**
 *  view的点击事件处理block
 */
@property (nonatomic, copy) DHBounceViewDidClickAction clickAction;

/**
 *  contentsFrame基于自身坐标系的frame
 */
@property (nonatomic, assign, readonly) CGRect privateContentsFrame;

- (instancetype)initWithContentsFrame:(CGRect)frame interval:(CGFloat)interval;

@end
