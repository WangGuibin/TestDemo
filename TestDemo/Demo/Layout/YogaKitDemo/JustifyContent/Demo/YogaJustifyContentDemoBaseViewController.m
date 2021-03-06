//
// YogaJustifyContentDemoBaseViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/24
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
    

#import "YogaJustifyContentDemoBaseViewController.h"

@interface YogaJustifyContentDemoBaseViewController ()

@end

@implementation YogaJustifyContentDemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bgView];
    [bgView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(KWIDTH-10);
        layout.height = YGPointValue(KHIGHT-200);
        layout.marginTop = layout.marginBottom = YGPointValue(100);
        layout.flexWrap = YGWrapWrap;//可以换行
        layout.flexDirection  = YGFlexDirectionRow;//水平布局方向即主轴
        layout.justifyContent = self.justifyType;
    }];

    
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor orangeColor];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = @(i+1).stringValue;
        [bgView addSubview:view];
        [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.margin = YGPointValue(5);
            layout.width = layout.height = YGPointValue(arc4random()%100+30);
        }];
    }
    
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull  layout) {
        layout.isEnabled = YES;
    }];
    [self.view.yoga applyLayoutPreservingOrigin:YES];
}

@end
