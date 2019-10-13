//
//  UIImageView+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "UIImageView+WGBExtension.h"
#import <objc/runtime.h>

@interface UIImageView ()
//是否存在观察者
@property (assign, nonatomic) BOOL addObserver;
//是否已经渲染
@property (assign, nonatomic) BOOL rendering;
@end

@implementation UIImageView (WGBExtension)

#pragma mark - 绘制圆角方法接口
-(void)addCorner:(CGFloat)radius andImage:(UIImage *)image
{
    if (self.rendering) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    self.image = [self imageAddCornerWithRadius:radius andSize:self.bounds.size andImage:image];
    [self layoutIfNeeded];
}

#pragma mark - 绘制圆角核心方法
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size andImage:(UIImage *)image{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [image drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 动态添加属性cornerRadius
- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, @selector(cornerRadius), @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.image == nil) {
        self.rendering = NO;
        if (!self.addObserver) {
            [[self class] swizzleDealloc];
            // 给动态的属性赋值时kvo观察image的变化
            [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
            self.addObserver = YES;
        }
    }else{
        self.rendering = NO;
        //调用绘制圆角方法接口
        [self addCorner:cornerRadius andImage:self.image];
    }
}


- (BOOL)addObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAddObserver:(BOOL)addObserver {
    objc_setAssociatedObject(self, @selector(addObserver), @(addObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rendering {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRendering:(BOOL)rendering {
    objc_setAssociatedObject(self, @selector(rendering), @(rendering), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        }
        if (self.rendering) {
            return;
        }
        if (newImage) {
            self.rendering = YES;
            [self addCorner:self.cornerRadius andImage:newImage];
        }
    }
}


#pragma mark - 交换方法
+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(wgb_dealloc)];
    });
}
- (void)wgb_dealloc {
    if (self.addObserver) {
        [self removeObserver:self forKeyPath:@"image"];
        NSLog(@"dealloc");
    }
    [self wgb_dealloc];
}

@end
