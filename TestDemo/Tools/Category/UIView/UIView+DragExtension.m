//
// UIView+DragExtension.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/15
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
    

#import "UIView+DragExtension.h"
#import <objc/runtime.h>
@interface UIView ()
@property (nonatomic,weak) UIPanGestureRecognizer *panG;
@property (nonatomic,assign) CGFloat wgb_x;
@property (nonatomic,assign) CGFloat wgb_y;
@property (nonatomic,assign) CGFloat wgb_centerX;
@property (nonatomic,assign) CGFloat wgb_centerY;
@property (nonatomic,assign) CGFloat wgb_width;
@property (nonatomic,assign) CGFloat wgb_height;
@end


@implementation UIView (DragExtension)

static char *static_wgb_canDrag = "static_wgb_canDrag";
static char *static_wgb_bounces = "static_wgb_bounces";
static char *static_wgb_adsorb = "static_wgb_adsorb";
static char *static_wgb_panG = "static_wgb_panG";
/**
 *
 *  控件当前的下标
 */
static NSUInteger _currentIndex;
/**
 *
 *  防止先设置bounces 再设置 wgb_canDrag 而重置wgb_bounces的值
 */
BOOL _bounces = YES;
BOOL _absorb = YES;

- (void)setWgb_canDrag:(BOOL)wgb_canDrag{
    objc_setAssociatedObject(self, &static_wgb_canDrag, @(wgb_canDrag), OBJC_ASSOCIATION_ASSIGN);
    if (wgb_canDrag) {
        [self wgb_addPanGesture];
        self.wgb_bounces = _bounces;
        self.wgb_isAdsorb = _absorb;
        _currentIndex = [self.superview.subviews indexOfObject:self];
    }
    else{
        [self wgb_removePanGesture];
    }
}

- (BOOL)wgb_canDrag{
    NSNumber *wgbagNum = objc_getAssociatedObject(self, &static_wgb_canDrag);
    return wgbagNum.boolValue;
}

- (void)setPanG:(UIPanGestureRecognizer *)panG{
    objc_setAssociatedObject(self, &static_wgb_panG, panG, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)panG{
    return objc_getAssociatedObject(self, &static_wgb_panG);
}

- (void)setWgb_bounces:(BOOL)wgb_bounces{
    objc_setAssociatedObject(self, &static_wgb_bounces, @(wgb_bounces), OBJC_ASSOCIATION_ASSIGN);
    _bounces = wgb_bounces;
}

- (BOOL)wgb_bounces{
    NSNumber *wgbagNum = objc_getAssociatedObject(self, &static_wgb_bounces);
    return wgbagNum.boolValue;
}

- (void)setWgb_isAdsorb:(BOOL)wgb_isAdsorb{
    objc_setAssociatedObject(self, &static_wgb_adsorb, @(wgb_isAdsorb), OBJC_ASSOCIATION_ASSIGN);
    _absorb = wgb_isAdsorb;
}

- (BOOL)wgb_isAdsorb{
    NSNumber *wgbagNum = objc_getAssociatedObject(self, &static_wgb_adsorb);
    return wgbagNum.boolValue;
}


#pragma mark -- private method

- (void)wgb_addPanGesture{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOperation:)];
    self.panG = panG;
    [self addGestureRecognizer:panG];
}

- (void)wgb_removePanGesture{
    [self removeGestureRecognizer:self.panG];
    self.panG = nil;
}

- (void)panOperation:(UIPanGestureRecognizer *)gesR{
    
    CGPoint translatedPoint = [gesR translationInView:self];
    CGFloat x = gesR.view.wgb_centerX + translatedPoint.x;
    CGFloat y = gesR.view.wgb_centerY + translatedPoint.y;
    
    switch (gesR.state) {
        case UIGestureRecognizerStateBegan:{
            // 遮盖处理
            [[self superview] bringSubviewToFront:self];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (!self.wgb_bounces) {
                if (x < self.wgb_width / 2) {
                    x = self.wgb_width / 2;
                }
                else if (x > self.superview.wgb_width - self.wgb_width / 2) {
                    x = self.superview.wgb_width - self.wgb_width / 2;
                }
                if (y < self.wgb_height / 2) {
                    y = self.wgb_width / 2;
                }
                else if(y > self.superview.wgb_height - self.wgb_height / 2){
                    y = self.superview.wgb_height - self.wgb_height / 2;
                }
            }
            gesR.view.center = CGPointMake(x, y);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self layoutIfNeeded];
            if (y < self.wgb_height / 2) {
                y = self.wgb_width / 2;
            }
            else if(y > self.superview.wgb_height - self.wgb_height / 2){
                y = self.superview.wgb_height - self.wgb_height / 2;
            }
            
            if (!self.wgb_isAdsorb) {
                if (gesR.view.wgb_x < self.superview.wgb_x) {
                    x = self.superview.wgb_x + gesR.view.wgb_width / 2;
                }
                else if (gesR.view.wgb_x + gesR.view.wgb_width > self.superview.wgb_width){
                    x = self.superview.wgb_width - gesR.view.wgb_width / 2;
                }
                [UIView animateWithDuration:0.25 animations:^{
                    gesR.view.center = CGPointMake(x, y);
                }];
            }
            else{
                // 此时需要加上父类的x值，比较的应该是绝对位置，而不是相对位置
                if (gesR.view.wgb_centerX + self.superview.wgb_x > self.superview.wgb_centerX) {
                    [UIView animateWithDuration:0.25 animations:^{
                        gesR.view.center = CGPointMake(self.superview.wgb_width - self.wgb_width / 2, y);
                    }];
                    
                }
                else{
                    [UIView animateWithDuration:0.25 animations:^{
                        gesR.view.center = CGPointMake(self.wgb_width / 2, y);
                    }];
                    
                }
            }
            // 遮盖处理，如果不遮盖，重置原来位置
            if (![self wgb_isCover]) {
                [self.superview insertSubview:self atIndex:_currentIndex];
            }
            else{
                [self.superview bringSubviewToFront:self];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            break;
        }
        case UIGestureRecognizerStateFailed:{
            NSAssert(YES, @"手势失败");
            break;
        }
        default:
            break;
    }
    // 重置
    [gesR setTranslation:CGPointMake(0, 0) inView:self];
}

- (BOOL)wgb_isCover{
    BOOL wgbag = NO;
    for (UIView *view in self.superview.subviews) {
        if (view == self) continue;
        if ([self wgb_intersectsWithView:view]) {
            wgbag = YES;
        }
    }
    return wgbag;
}

- (BOOL)wgb_intersectsWithView:(UIView *)view{
    //都先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}


- (CGFloat)wgb_x{
    return self.frame.origin.x;
}

- (CGFloat)wgb_y{
    return self.frame.origin.y;
}

- (CGFloat)wgb_centerX{
    return self.center.x;
}

- (CGFloat)wgb_centerY{
    return self.center.y;
}

- (CGFloat)wgb_width{
    return self.frame.size.width;
}

- (CGFloat)wgb_height{
    return self.frame.size.height;
}

- (void)setWgb_x:(CGFloat)wgb_x{
    self.frame = (CGRect){
        .origin = {.x = wgb_x, .y = self.wgb_y},
        .size   = {.width = self.wgb_width, .height = self.wgb_height}
    };
}

- (void)setWgb_y:(CGFloat)wgb_y{
    self.frame = (CGRect){
        .origin = {.x = self.wgb_x, .y = wgb_y},
        .size   = {.width = self.wgb_width, .height = self.wgb_height}
    };
}

- (void)setWgb_centerX:(CGFloat)wgb_centerX{
    CGPoint center = self.center;
    center.x = wgb_centerX;
    self.center = center;
}

- (void)setWgb_centerY:(CGFloat)wgb_centerY{
    CGPoint center = self.center;
    center.y = wgb_centerY;
    self.center = center;
}


- (void)setWgb_width:(CGFloat)wgb_width{
    self.frame = (CGRect){
        .origin = {.x = self.wgb_x, .y = self.wgb_y},
        .size   = {.width = wgb_width, .height = self.wgb_height}
    };
}

- (void)setWgb_height:(CGFloat)wgb_height{
    self.frame = (CGRect){
        .origin = {.x = self.wgb_x, .y = self.wgb_y},
        .size   = {.width = self.wgb_width, .height = self.wgb_height}
    };
}
@end

