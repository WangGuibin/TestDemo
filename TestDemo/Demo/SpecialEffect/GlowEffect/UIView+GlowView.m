//
// UIView+GlowView.m
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
    

#import "UIView+GlowView.h"

#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) CALayer           *glowLayer;
@property (nonatomic, strong) dispatch_source_t  dispatchSource;

@end

@implementation UIView (GlowView)

- (void)createGlowLayer {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
    [[self accessGlowColor] setFill];
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1.0];
    
    self.glowLayer               = [CALayer layer];
    self.glowLayer.frame         = self.bounds;
    self.glowLayer.contents      = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    self.glowLayer.opacity       = 0.f;
    self.glowLayer.shadowOffset  = CGSizeMake(0, 0);
    self.glowLayer.shadowOpacity = 1.f;
    
    UIGraphicsEndImageContext();
}

- (void)insertGlowLayer {

    if (self.glowLayer) {
        
        [self.layer addSublayer:self.glowLayer];
    }
}

- (void)removeGlowLayer {

    if (self.glowLayer) {
        
        [self.glowLayer removeFromSuperlayer];
    }
}

- (void)glowToshow {
    
    self.glowLayer.shadowColor   = [self accessGlowColor].CGColor;
    self.glowLayer.shadowRadius  = [self accessGlowRadius].floatValue;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue         = @(0.f);
    animation.toValue           = [self accessGlowOpacity];
    self.glowLayer.opacity      = [self accessGlowOpacity].floatValue;
    animation.duration          = [self accessAnimationDuration].floatValue;
    
    [self.glowLayer addAnimation:animation forKey:nil];
}

- (void)glowToHide {
    
    self.glowLayer.shadowColor   = [self accessGlowColor].CGColor;
    self.glowLayer.shadowRadius  = [self accessGlowRadius].floatValue;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue         = [self accessGlowOpacity];
    animation.toValue           = @(0.f);
    self.glowLayer.opacity      = 0.f;
    animation.duration          = [self accessAnimationDuration].floatValue;
    
    [self.glowLayer addAnimation:animation forKey:nil];
}

- (void)startGlowLoop {

    if (self.dispatchSource == nil) {

        CGFloat seconds      = [self accessAnimationDuration].floatValue * 2 + [self accessGlowDuration].floatValue + [self accessHideDuration].floatValue;
        CGFloat delaySeconds = [self accessAnimationDuration].floatValue + [self accessGlowDuration].floatValue;
        
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC * seconds, 0);
        dispatch_source_set_event_handler(self.dispatchSource, ^{
            
            [self glowToshow];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delaySeconds), dispatch_get_main_queue(), ^{
                
                [self glowToHide];
            });
        });
        
        dispatch_resume(self.dispatchSource);
    }
}

#pragma mark - 处理数据越界问题

- (NSNumber *)accessGlowOpacity {

    if (self.glowOpacity) {
        
        if (self.glowOpacity.floatValue <= 0 || self.glowOpacity.floatValue > 1) {
            
            return @(0.8);
            
        } else {
            
            return self.glowOpacity;
        }
        
    } else {
    
        return @(0.8);
    }
}

- (NSNumber *)accessGlowDuration {

    if (self.glowDuration) {
        
        if (self.glowDuration.floatValue <= 0) {
            
            return @(0.5f);
            
        } else {
            
            return self.glowDuration;
        }
        
    } else {
        
        return @(0.5f);
    }
}

- (NSNumber *)accessHideDuration {

    if (self.hideDuration) {
        
        if (self.hideDuration.floatValue < 0) {
            
            return @(0.5);
            
        } else {
            
            return self.hideDuration;
        }
        
    } else {
        
        return @(0.5f);
    }
}

- (NSNumber *)accessAnimationDuration {
    
    if (self.glowAnimationDuration) {
        
        if (self.glowAnimationDuration.floatValue <= 0) {
            
            return @(1.f);
            
        } else {
            
            return self.glowAnimationDuration;
        }
        
    } else {
        
        return @(1.f);
    }
}

- (UIColor *)accessGlowColor {

    if (self.glowColor) {
        
        return self.glowColor;
        
    } else {
        
        return [UIColor redColor];
    }
}

- (NSNumber *)accessGlowRadius {

    if (self.glowRadius) {
        
        if (self.glowRadius.floatValue <= 0) {
            
            return @(2.f);
            
        } else {
            
            return self.glowRadius;
        }
        
    } else {
        
        return @(2.f);
    }
}

#pragma mark - runtime属性

NSString * const _recognizerDispatchSource = @"_recognizerDispatchSource";

- (void)setDispatchSource:(dispatch_source_t)dispatchSource {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerDispatchSource), dispatchSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)dispatchSource {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerDispatchSource));
}

NSString * const _recognizerGlowColor = @"_recognizerGlowColor";

- (void)setGlowColor:(UIColor *)glowColor {
    
    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowColor), glowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)glowColor {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowColor));
}

NSString * const _recognizerGlowOpacity = @"_recognizerGlowOpacity";

- (void)setGlowOpacity:(NSNumber *)glowOpacity {

    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowOpacity), glowOpacity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)glowOpacity {

    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowOpacity));
}

NSString * const _recognizerGlowRadius = @"_recognizerGlowRadius";

- (void)setGlowRadius:(NSNumber *)glowRadius {

    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowRadius), glowRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)glowRadius {

    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowRadius));
}

NSString * const _recognizerGlowAnimationDuration = @"_recognizerGlowAnimationDuration";

- (void)setGlowAnimationDuration:(NSNumber *)glowAnimationDuration {

    objc_setAssociatedObject(self, (__bridge const void *)(glowAnimationDuration), _recognizerGlowAnimationDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)glowAnimationDuration {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowAnimationDuration));
}

NSString * const _recognizerGlowDuration = @"_recognizerGlowDuration";

- (void)setGlowDuration:(NSNumber *)glowDuration {

    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowDuration), glowDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)glowDuration {

    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowDuration));
}

NSString * const _recognizerHideDuration = @"_recognizerHideDuration";

- (void)setHideDuration:(NSNumber *)hideDuration {

    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerHideDuration), hideDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)hideDuration {

    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerHideDuration));
}

NSString * const _recognizerGlowLayer = @"_recognizerGlowLayer";

- (void)setGlowLayer:(CALayer *)glowLayer {

    objc_setAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer), glowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)glowLayer {
    
    return objc_getAssociatedObject(self, (__bridge const void *)(_recognizerGlowLayer));
}
@end
