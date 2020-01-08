//
// UIScrollView+WGBFloatingHeader.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/1/8
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
    

#import "UIScrollView+WGBFloatingHeader.h"
#import <objc/runtime.h>

static void * WGBFloatingHeaderViewKey = &WGBFloatingHeaderViewKey;
static void * WGBFloatingHeaderViewContext = &WGBFloatingHeaderViewContext;


@implementation UIScrollView (WGBFloatingHeader)

#pragma mark - Setters/Getters
-(UIView *)floatingHeaderView{
    return objc_getAssociatedObject(self, WGBFloatingHeaderViewKey);
}

-(void)setFloatingHeaderView:(UIView *)headerView{
    [self _handlePreviousHeaderView];
    
    objc_setAssociatedObject(self, WGBFloatingHeaderViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self _handleNewHeaderView];
}
#pragma mark - Handle add/remove of views;
-(void)_handlePreviousHeaderView{
    UIView* previousHeaderView = [self floatingHeaderView];
    if(previousHeaderView != nil){
        UIEdgeInsets contentInset = [self contentInset];
        UIEdgeInsets scrollInset = [self scrollIndicatorInsets];
        contentInset.top-=previousHeaderView.frame.size.height;
        scrollInset.top-=previousHeaderView.frame.size.height;
        [self setContentInset:contentInset];
        [self setScrollIndicatorInsets:scrollInset];
        [previousHeaderView removeFromSuperview];
        @try {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        @catch (NSException * __unused exception) {
        
        }
        previousHeaderView = nil;

    }
}
-(void)_handleNewHeaderView{
    if(self.floatingHeaderView!=nil){
        [self addSubview:self.floatingHeaderView];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:WGBFloatingHeaderViewContext];
        [self.floatingHeaderView setFrame:CGRectMake(0, -self.floatingHeaderView.frame.size.height, self.frame.size.width, self.floatingHeaderView.frame.size.height)];
        UIEdgeInsets contentInset = [self contentInset];
        UIEdgeInsets scrollInset = [self scrollIndicatorInsets];
        contentInset.top+=self.floatingHeaderView.frame.size.height;
        scrollInset.top+=self.floatingHeaderView.frame.size.height;
        [self setContentInset:contentInset];
        [self setScrollIndicatorInsets:scrollInset];
        [self setContentOffset:CGPointMake(0, -self.floatingHeaderView.frame.size.height)];
    }
}

#pragma mark - Scroll Logic
/*
 * Three scrollStates:
 * - Fast Swipe up + header not visible = start showing the header
 * - Header is showing at least part of itself: scroll it by the content offset difference (with a maximum of the top offset)
 * - Header is completely showing = header should not scroll any more
 */
-(void)_scrolledFromOffset:(CGFloat)oldYOffset toOffset:(CGFloat)newYOffset{
    CGPoint scrollVelocity = [[self panGestureRecognizer] velocityInView:self];
    BOOL fastSwipe = NO;
    if(ABS(scrollVelocity.y)>1000){
        fastSwipe = YES;
    }
    BOOL isHeaderShowing = self.floatingHeaderView.frame.origin.y+self.floatingHeaderView.frame.size.height>=newYOffset;
    BOOL isHeaderCompletelyShowing = self.floatingHeaderView.frame.origin.y >= oldYOffset;

    if(fastSwipe && !isHeaderShowing && oldYOffset>newYOffset){
        CGFloat difference = oldYOffset-newYOffset;
        CGRect floatingFrame = self.floatingHeaderView.frame;
        floatingFrame.origin.y = newYOffset - floatingFrame.size.height + difference;
        if(floatingFrame.origin.y>newYOffset)
            floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
    }
    if(isHeaderShowing){
        CGFloat difference = oldYOffset-newYOffset;
        CGRect floatingFrame = self.floatingHeaderView.frame;
//        floatingFrame.origin.y = floatingFrame.origin.y  + difference;
        if(floatingFrame.origin.y>newYOffset)
            floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
    }
    if(isHeaderCompletelyShowing && newYOffset<-self.floatingHeaderView.frame.size.height){
        CGRect floatingFrame = self.floatingHeaderView.frame;
        floatingFrame.origin.y = newYOffset;
        [self.floatingHeaderView setFrame:floatingFrame];
        
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if (context == WGBFloatingHeaderViewContext) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGFloat oldYOffset = [[change objectForKey:@"old"]CGPointValue].y;
            CGFloat newYOffset = [[change objectForKey:@"new"]CGPointValue].y;
            [self _scrolledFromOffset:oldYOffset toOffset:newYOffset];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeContentOffsetObserver {
    [self removeObserver:self forKeyPath:@"contentOffset" context:WGBFloatingHeaderViewContext];
}





@end
