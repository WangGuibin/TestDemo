//
//  WGBUIViewMaker.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WGBUIViewMaker : NSObject

/**
 设置frame
 */
- (WGBUIViewMaker *(^)(CGRect))frame;

/**
 背景色
 */
- (WGBUIViewMaker *(^)(UIColor *))backgroundColor;

/**
 返回UIView对象

 @return view
 */
- (id)view;
@end

@interface WGBUILabelMaker : NSObject

- (WGBUILabelMaker *(^)(CGRect))frame;
- (WGBUILabelMaker *(^)(UIColor *))backgroundColor ;
- (WGBUILabelMaker *(^)(UIFont*))font;
- (WGBUILabelMaker *(^)(NSString *))text;
- (WGBUILabelMaker *(^)(UIColor *))textColor;
- (WGBUILabelMaker *(^)(NSTextAlignment))textAlignment;
- (WGBUILabelMaker *(^)(NSAttributedString *))attributedText;
- (WGBUILabelMaker *(^)(NSInteger))numberOfLines;
- (id)view;
@end


@interface WGBUIButtonMaker : NSObject
- (WGBUIButtonMaker *(^)(CGRect))frame;
- (WGBUIButtonMaker *(^)(UIColor *))backgroundColor ;
- (WGBUIButtonMaker *(^)(UIFont*))font;
- (WGBUIButtonMaker *(^)(NSString *,UIControlState))titleAndState;
- (WGBUIButtonMaker *(^)(UIColor *,UIControlState))textColorAndState;
- (WGBUIButtonMaker *(^)(UIImage *,UIControlState))imageAndState;
- (WGBUIButtonMaker *(^)(UIImage *,UIControlState))backgroundImageAndState;
- (WGBUIButtonMaker *(^)(NSAttributedString *,UIControlState))attributedTextAndState;
- (id)view;
@end

@interface WGBUIImageViewMaker : NSObject

- (WGBUIImageViewMaker *(^)(CGRect))frame;
- (WGBUIImageViewMaker *(^)(UIColor *))backgroundColor ;
- (WGBUIImageViewMaker *(^)(UIImage *))image;

- (id)view;
@end

