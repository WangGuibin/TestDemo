//
// FBGlowLabel.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/23
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "FBGlowLabel.h"

@implementation FBGlowLabel

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    if (self = [super initWithCoder:coder]) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.glowSize       = 0.0f;
    self.glowColor      = [UIColor clearColor];
    
    self.innerGlowSize  = 0.0f;
    self.innerGlowColor = [UIColor clearColor];
}

- (void)drawTextInRectForIOS7:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    [super drawTextInRect:rect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGContextSaveGState(ctx);
    
    if (_glowSize > 0) {
        
        CGContextSetShadow(ctx, CGSizeZero, _glowSize);
        CGContextSetShadowWithColor(ctx, CGSizeZero, _glowSize, _glowColor.CGColor);
    }
    
    [textImage drawAtPoint:rect.origin];
    CGContextRestoreGState(ctx);
    
    if (_innerGlowSize > 0) {

        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        CGContextRef ctx2 = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx2);
        CGContextSetFillColorWithColor(ctx2, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx2, rect);
        CGContextTranslateCTM(ctx2, 0.0, rect.size.height);
        CGContextScaleCTM(ctx2, 1.0, -1.0);
        CGContextClipToMask(ctx2, rect, textImage.CGImage);
        CGContextClearRect(ctx2, rect);
        CGContextRestoreGState(ctx2);
        
        UIImage *inverted = UIGraphicsGetImageFromCurrentImageContext();
        CGContextClearRect(ctx2, rect);
        
        CGContextSaveGState(ctx2);
        CGContextSetFillColorWithColor(ctx2, _innerGlowColor.CGColor);
        CGContextSetShadowWithColor(ctx2, CGSizeZero, _innerGlowSize, _innerGlowColor.CGColor);
        [inverted drawAtPoint:CGPointZero];
        CGContextTranslateCTM(ctx2, 0.0, rect.size.height);
        CGContextScaleCTM(ctx2, 1.0, -1.0);
        CGContextClipToMask(ctx2, rect, inverted.CGImage);
        CGContextClearRect(ctx2, rect);
        CGContextRestoreGState(ctx2);
        
        UIImage *innerShadow = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [innerShadow drawAtPoint:rect.origin];
    }
}

- (void)drawTextInRectForIOS6:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    if (self.glowSize > 0) {
        
        CGContextSetShadow(ctx, CGSizeZero, _glowSize);
        CGContextSetShadowWithColor(ctx, CGSizeZero, _glowSize, _glowColor.CGColor);
    }
    
    [super drawTextInRect:rect];
    CGContextRestoreGState(ctx);
    
    if (_innerGlowSize > 0) {

        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        
        CGContextRef ctx2 = UIGraphicsGetCurrentContext();
        [super drawTextInRect:rect];
        
        UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
        CGContextClearRect(ctx2, rect);
        
        CGContextSaveGState(ctx2);
        CGContextSetFillColorWithColor(ctx2, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx2, rect);
        CGContextTranslateCTM(ctx2, 0.0, rect.size.height);
        CGContextScaleCTM(ctx2, 1.0, -1.0);
        CGContextClipToMask(ctx2, rect, textImage.CGImage);
        CGContextClearRect(ctx2, rect);
        CGContextRestoreGState(ctx2);
        
        UIImage *inverted = UIGraphicsGetImageFromCurrentImageContext();
        CGContextClearRect(ctx2, rect);
        
        CGContextSaveGState(ctx2);
        CGContextSetFillColorWithColor(ctx2, _innerGlowColor.CGColor);
        CGContextSetShadowWithColor(ctx2, CGSizeZero, _innerGlowSize, _innerGlowColor.CGColor);
        [inverted drawAtPoint:CGPointZero];
        CGContextTranslateCTM(ctx2, 0.0, rect.size.height);
        CGContextScaleCTM(ctx2, 1.0, -1.0);
        CGContextClipToMask(ctx2, rect, inverted.CGImage);
        CGContextClearRect(ctx2, rect);
        CGContextRestoreGState(ctx2);
        
        UIImage *innerShadow = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [innerShadow drawAtPoint:rect.origin];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    
    if (self.text == nil || self.text.length == 0) {
        
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        
        [self drawTextInRectForIOS7:rect];
        
    } else {
        
        [self drawTextInRectForIOS6:rect];
    }
}

@end
