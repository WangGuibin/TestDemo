//
// UIView+BoomBoomBoom.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/18
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
    

#import "UIView+BoomBoomBoom.h"

@implementation UIView (BoomBoomBoom)

///MARK:- 爆炸动画效果
- (void)explosionBoomBoomBoom{
    // 先截图
    UIView *snapView = [self snapshotViewAfterScreenUpdates:YES];
    // 隐藏容器中的子控件
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
    
    // 保存x坐标的数组
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    // 保存y坐标
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    CGFloat margin = 30;
    for (NSInteger i = 0; i < self.bounds.size.width; i = i + 10) {
        [xArray addObject:@(i+margin)];
    }
    for (NSInteger i = 0; i < self.bounds.size.height; i = i + 10) {
        [yArray addObject:@(i-margin)];
    }

    //这个保存所有的碎片
    NSMutableArray *snapshots = [[NSMutableArray alloc] init];
    for (NSNumber *x in xArray) {
        
        for (NSNumber *y in yArray) {
            CGRect snapshotRegion = CGRectMake([x doubleValue], [y doubleValue], 10, 10);
            
            // resizableSnapshotViewFromRect 这个方法就是根据frame 去截图
            UIView *snapshot  = [snapView resizableSnapshotViewFromRect:snapshotRegion afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame  = snapshotRegion;
            [self.superview addSubview: snapshot];
            [snapshots addObject:snapshot];
        }
    }
    
    self.hidden = YES;
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        for (UIView *view in snapshots) {
            view.frame = CGRectOffset(view.frame, [self randomRange:300 offset:-100], [self randomRange:300 offset:[UIScreen mainScreen].bounds.size.height/2.0]);
        }
    } completion:^(BOOL finished) {
        for (UIView *view in snapshots) {
            [view removeFromSuperview];
        }
    }];
}

- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset{
    return (CGFloat)(arc4random()%range + offset);
}


@end
