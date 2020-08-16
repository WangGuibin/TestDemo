//
// WGBMasonryDemoListViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/16
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
    

#import "WGBMasonryDemoListViewController.h"
#import "WGBMasonryHorizontalLayoutViewController.h"
#import "WGBMasonryItemFlexedLayoutViewController.h"
#import "WGBMasonrySudokuDemoViewController.h"
#import "WGBMasonrySubViewHoldUpSupViewDemoViewController.h"
#import "WGBMasonryScrollViewDemoViewController.h"
#import "WGBMasonryConstraintsAnimationDemoViewController.h"

@interface WGBMasonryDemoListViewController ()

@end

@implementation WGBMasonryDemoListViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBMasonryHorizontalLayoutViewController class],
        [WGBMasonryItemFlexedLayoutViewController class],
        [WGBMasonrySudokuDemoViewController class],
        [WGBMasonrySubViewHoldUpSupViewDemoViewController class],
        [WGBMasonryScrollViewDemoViewController class],
        [WGBMasonryConstraintsAnimationDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"横向和纵向布局(固定item间距)",//根据item之间的间距
        @"横向和纵向布局(固定item宽度或者高度)",//根据item某一方向上的固定长度
        @"九宫格布局",
        @"子视图撑起父视图",
        @"UIScrollView布局",
        @"约束动画"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

@end
