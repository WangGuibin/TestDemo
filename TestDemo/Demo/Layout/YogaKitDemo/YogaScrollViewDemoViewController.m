//
// YogaScrollViewDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/13
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
    

#import "YogaScrollViewDemoViewController.h"

@interface YogaScrollViewDemoViewController ()

@end

@implementation YogaScrollViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    
}

- (void)setup{
 
    UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectZero];
    placeholderView.backgroundColor = [UIColor redColor];
    [self.view addSubview: placeholderView];
    [placeholderView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.height = YGPointValue(100);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: scrollView];
    [scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;//水平排布
        layout.height = YGPointValue(200);
        layout.padding = YGPointValue(10);
    }];

    for (NSInteger i = 0; i < 10; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [scrollView addSubview: view];
        [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.marginLeft = YGPointValue(10);
            layout.width = layout.height = YGPointValue(180);
        }];
    }
    
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull  layout) {
        layout.isEnabled = YES;
        layout.marginTop = YGPointValue(20);
        layout.flexDirection  = YGFlexDirectionColumn;//垂直布局
    }];
    
    
    UIScrollView *scrollView01 = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview: scrollView01];
    [scrollView01 configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionColumn;//垂直布局
        layout.height = YGPointValue([UIScreen mainScreen].bounds.size.height-300);
    }];

    UIView * contentview = [[UIView alloc] init];
    [scrollView01 addSubview:contentview];

    [contentview configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.alignItems = YGAlignCenter;
        layout.flexDirection = YGFlexDirectionColumn;
        layout.padding = YGPointValue(5);
    }];
    
    for ( int i = 1 ; i <= 10 ; i++ ){
        UIView *item = [UIView new];
        item.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];;
        [item configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.height = YGPointValue(20*i) ;
            layout.width = YGPointValue([UIScreen mainScreen].bounds.size.width - 20);
            layout.marginLeft = YGPointValue(10);
            layout.marginRight = YGPointValue(10);
        }];
        [contentview addSubview:item];
    }
    
    [self.view.yoga applyLayoutPreservingOrigin:YES];
    scrollView.contentSize = CGSizeMake(2000, 200);
    scrollView01.contentSize = contentview.bounds.size;

}

@end
