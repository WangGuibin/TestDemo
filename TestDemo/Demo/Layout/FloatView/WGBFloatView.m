//
// WGBFloatView.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/9
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
    

#import "WGBFloatView.h"


@implementation WGBFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)rec {
    if (self.clickActionBlock) {
        self.clickActionBlock();
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)rec {
    UIView *superView = self.superview;
    CGPoint point = [rec translationInView:superView];
    CGFloat centerX = rec.view.center.x+point.x;
    CGFloat centerY = rec.view.center.y+point.y;
    
    CGFloat viewHalfH = rec.view.frame.size.height/2;
    CGFloat viewhalfW = rec.view.frame.size.width/2;
    
    if (centerY - viewHalfH < 0 ) {
        centerY = viewHalfH;
    }
    
    if (centerY + viewHalfH > superView.height) {
        centerY = superView.height - viewHalfH;
    }
    
    if (centerX - viewhalfW < 0){
        centerX = viewhalfW;
    }
    
    if (centerX + viewhalfW > superView.width){
        centerX = superView.width - viewhalfW;
    }
    
    rec.view.center = CGPointMake(centerX, centerY);
    [rec setTranslation:CGPointMake(0, 0) inView:superView];
    
    // 拖动结束后才能继续执行下面计算
    if (rec.state != UIGestureRecognizerStateEnded) return;
    
    // 计算x轴最终位置
    if (rec.view.right > (superView.width/2)) {
        self.x = superView.width - self.width;
    } else {
        self.x = 0;
    }
    
    CGFloat navH = 0.f;
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // 处理加载在windows上或VC上顶部距离
    BOOL isWindows = [superView isKindOfClass:[UIWindow class]];
    if (isWindows) {
        navH = statusBarH;
    } else {
        // 处理状态栏隐藏状态
        UIViewController *responder = [self getViewController];
        BOOL isNavigationBarHidden = responder.navigationController.isNavigationBarHidden;
        if ([responder.navigationController isKindOfClass:[UINavigationController class]]) {
            if (isNavigationBarHidden) {
                // 导航栏隐藏
                navH = statusBarH;
            } else if (responder.navigationController.navigationBar.translucent) {
                // 导航栏透明
                navH = statusBarH + responder.navigationController.navigationBar.height;
            }
        } else {
            navH = statusBarH;
        }
    }
    
    CGFloat topH = rec.view.y < navH ? navH : rec.view.y;
    // iPhone X 需要加上底部安全区域高度
    CGFloat buoyBottom = isIphoneX()? (rec.view.bottom+superView.y) + 34 : (rec.view.bottom+superView.y);
    
    // 浮标+底部安全区域高度 >= 父类容器高度
    if (buoyBottom >= superView.height) {
        if (isIphoneX()) {
            // 父类容器高度 - 浮标高度 - 底部安全区域高度
            self.top = superView.height - self.height - 34;
        } else {
            self.top = superView.height - self.height;
        }
    } else {
        self.top = topH;
    }
    
    [superView setNeedsUpdateConstraints];
    [superView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [superView layoutIfNeeded];
    }];
}

- (UIViewController *)getViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
