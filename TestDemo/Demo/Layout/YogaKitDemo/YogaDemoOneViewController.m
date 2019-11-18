//
// YogaDemoOneViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/9
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
    

#import "YogaDemoOneViewController.h"

@interface YogaDemoOneViewController ()

@end

@implementation YogaDemoOneViewController

///MARK:- 热重载调用方法
- (void)injected{
    [self viewDidLoad];
    NSLog(@"I've been injected: %@", self);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *testView = [[UIView alloc] initWithFrame:CGRectZero];
    testView.backgroundColor = [UIColor blueColor];
    [self.view addSubview: testView];
    ViewRadius(testView, 30);
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectZero];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview: redView];

    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectZero];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview: yellowView];
    
    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;//是否允许调整布局属性
        layout.justifyContent = YGJustifyCenter;
        layout.alignItems = YGAlignCenter;
    }];
    
    [testView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.margin = YGPointValue(20);
        layout.width = layout.height = YGPointValue(200);
    }];

    [redView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = layout.height = YGPointValue(200);
        layout.borderWidth = 30;
        layout.flexGrow = 0.5;
    }];
    
    [yellowView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = layout.height = YGPointValue(200);
    }];

    //是否提供参考坐标起点 更新视图布局
    [self.view.yoga applyLayoutPreservingOrigin:YES];
    
}


@end
