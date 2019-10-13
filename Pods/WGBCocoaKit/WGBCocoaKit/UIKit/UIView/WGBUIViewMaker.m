//
//  WGBUIViewMaker.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "WGBUIViewMaker.h"

@interface WGBUIViewMaker()

@property(nonatomic, strong) UIView *tempView;

@end

@implementation WGBUIViewMaker

- (instancetype)init {
    if (self = [super init]) {
        self.tempView = [UIView new];
    }
    return self;
}


- (WGBUIViewMaker *(^)(CGRect))frame {
    return ^WGBUIViewMaker *(CGRect frame) {
         self.tempView.frame = frame;
        return self;
    };
}

- (WGBUIViewMaker *(^)(UIColor *))backgroundColor {
    return ^WGBUIViewMaker *(UIColor *backgroundColor) {
        self.tempView.backgroundColor = backgroundColor;
        return self;
    };
}


- (id)view {
    return self.tempView;
}

@end


@interface WGBUILabelMaker()

@property (nonatomic,strong) UILabel *label;

@end



@implementation WGBUILabelMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.label = [UILabel new];
    }
    return self;
}

- (WGBUILabelMaker *(^)(CGRect))frame {
    return ^WGBUILabelMaker *(CGRect frame) {
        self.label.frame = frame;
        return self;
    };
}

- (WGBUILabelMaker *(^)(UIColor *))backgroundColor {
    return ^WGBUILabelMaker *(UIColor *backgroundColor) {
        self.label.backgroundColor = backgroundColor;
        return self;
    };
}

- (WGBUILabelMaker *(^)(UIFont*))font{
    return ^WGBUILabelMaker*(UIFont *font){
        self.label.font = font;
        return self;
    };
}
- (WGBUILabelMaker *(^)(NSString *))text{
    return ^WGBUILabelMaker*(NSString *txt){
        self.label.text = txt;
        return self;
    };
}
- (WGBUILabelMaker *(^)(UIColor *))textColor{
    return ^WGBUILabelMaker*(UIColor *color){
        self.label.textColor = color;
        return self;
    };
}
- (WGBUILabelMaker *(^)(NSTextAlignment))textAlignment{
    return ^WGBUILabelMaker*(NSTextAlignment align){
        self.label.textAlignment = align;
        return self;
    };
}
- (WGBUILabelMaker *(^)(NSAttributedString *))attributedText{
    return ^WGBUILabelMaker*(NSAttributedString *attributeStr){
        self.label.attributedText = attributeStr;
        return self;
    };
}
- (WGBUILabelMaker *(^)(NSInteger))numberOfLines{
    return ^WGBUILabelMaker*(NSInteger num){
        self.label.numberOfLines = num;
        return self;
    };
}

- (id)view{
    return self.label;
}

@end


@interface WGBUIButtonMaker()

@property (nonatomic,strong) UIButton *button;

@end

@implementation WGBUIButtonMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.button = [UIButton new];
    }
    return self;
}

- (WGBUIButtonMaker *(^)(CGRect))frame{
    return ^WGBUIButtonMaker *(CGRect frame) {
        self.button.frame = frame;
        return self;
    };
}
- (WGBUIButtonMaker *(^)(UIColor *))backgroundColor {
    return ^WGBUIButtonMaker *(UIColor *bgColor) {
        self.button.backgroundColor = bgColor;
        return self;
    };
}
- (WGBUIButtonMaker *(^)(UIFont*))font{
    return ^WGBUIButtonMaker *(UIFont *font) {
        self.button.titleLabel.font = font;
        return self;
    };
}

- (WGBUIButtonMaker *(^)(NSString *,UIControlState))titleAndState{
    return ^WGBUIButtonMaker *(NSString*title,UIControlState state) {
        [self.button setTitle: title forState: state];
        return self;
    };
}
- (WGBUIButtonMaker *(^)(UIColor *,UIControlState))textColorAndState{
    return ^WGBUIButtonMaker *(UIColor*titleColor,UIControlState state) {
        [self.button setTitleColor: titleColor  forState: state];
        return self;
    };
}
- (WGBUIButtonMaker *(^)(UIImage *,UIControlState))imageAndState{
    return ^WGBUIButtonMaker *(UIImage*img,UIControlState state) {
        [self.button setImage: img  forState: state];
        return self;
    };
}
- (WGBUIButtonMaker *(^)(UIImage *,UIControlState))backgroundImageAndState{
    return ^WGBUIButtonMaker *(UIImage*bgImg,UIControlState state) {
        [self.button setBackgroundImage: bgImg forState: state];
        return self;
    };
}

- (WGBUIButtonMaker *(^)(NSAttributedString *,UIControlState))attributedTextAndState{
    return ^WGBUIButtonMaker *(NSAttributedString*attributeStr,UIControlState state) {
        [self.button setAttributedTitle: attributeStr forState: state];
        return self;
    };
}
- (id)view{
    return self.button;
}

@end



@interface WGBUIImageViewMaker()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation WGBUIImageViewMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageView = [UIImageView new];
    }
    return self;
}

- (WGBUIImageViewMaker *(^)(CGRect))frame{
    return ^WGBUIImageViewMaker*(CGRect rect){
        self.imageView.frame = rect;
        return self;
    };
}
- (WGBUIImageViewMaker *(^)(UIColor *))backgroundColor{
    return ^WGBUIImageViewMaker*(UIColor *bgColor){
        self.imageView.backgroundColor = bgColor;
        return self;
    };
}
- (WGBUIImageViewMaker *(^)(UIImage *))image{
    return ^WGBUIImageViewMaker*(UIImage *img){
        self.imageView.image = img;
        return self;
    };
}

- (id)view{
    return self.imageView;
}

@end



