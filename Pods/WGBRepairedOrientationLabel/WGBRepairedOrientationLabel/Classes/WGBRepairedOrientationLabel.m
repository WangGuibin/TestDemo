//
//  WGBRepairedOrientationLabel.m
//  WGBRepairedOrientationLabel
//
//  Created by mac on 2019/9/16.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import "WGBRepairedOrientationLabel.h"

@implementation WGBRepairedOrientationLabel

- (void)setAlignType:(WGBRepairedTextAlignType)alignType{
    _alignType = alignType;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    if (self.alignType == WGBRepairedTextAlignTypeTop) {
        textRect.origin.y = bounds.origin.y;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeLeft) {
        textRect.origin.x = bounds.origin.x;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeBottom) {
        textRect.origin.y = bounds.size.height - textRect.size.height;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeRight) {
        textRect.origin.x = bounds.size.width - textRect.size.width;
    }

    if (self.alignType == WGBRepairedTextAlignTypeHorizontalVerticalCenter) {
        textRect.origin.x = (bounds.size.width - textRect.size.width)*0.5;
        textRect.origin.y = (bounds.size.height - textRect.size.height)*0.5;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeHorizontalTopCenter) {
        textRect.origin.x = (bounds.size.width - textRect.size.width)*0.5;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeHorizontalBottomCenter) {
        textRect.origin.x = (bounds.size.width - textRect.size.width)*0.5;
    }

    if (self.alignType == WGBRepairedTextAlignTypeVerticalLeftCenter) {
        textRect.origin.y = (bounds.size.height - textRect.size.height)*0.5;
    }

    if (self.alignType == WGBRepairedTextAlignTypeVerticalRightCenter) {
        textRect.origin.y = (bounds.size.height - textRect.size.height)*0.5;
    }
    
    if (self.alignType == WGBRepairedTextAlignTypeLeftTop) {
        textRect.origin.x = bounds.origin.x;
        textRect.origin.y = bounds.origin.y;
    }

    if (self.alignType == WGBRepairedTextAlignTypeLeftBottom) {
        textRect.origin.x = bounds.origin.x;
        textRect.origin.y = bounds.size.height - textRect.size.height;
    }

    if (self.alignType == WGBRepairedTextAlignTypeRightTop) {
        textRect.origin.x = bounds.size.width - textRect.size.width;
        textRect.origin.y = bounds.origin.y;
    }

    if (self.alignType == WGBRepairedTextAlignTypeRightBottom) {
        textRect.origin.x = bounds.size.width - textRect.size.width;
        textRect.origin.y = bounds.size.height - textRect.size.height;
    }

    return textRect;
}


- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = requestedRect;
    if (self.alignType) {
        actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    }
    [super drawTextInRect:actualRect];
}

@end
