//
// YogaKitDemoViewController.m
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
    

#import "YogaKitDemoViewController.h"
#import "YogaDemoOneViewController.h"
#import "YogaScrollViewDemoViewController.h"
#import "YogaKitFlexDirectionDemoViewController.h"
#import "YogaKitJustifyContentViewController.h"
#import "YogaKitAlignItemsViewController.h"

@interface YogaKitDemoViewController () 

@end

@implementation YogaKitDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [YogaDemoOneViewController class],
        [YogaScrollViewDemoViewController class],
        [YogaKitFlexDirectionDemoViewController class],
        [YogaKitJustifyContentViewController class],
        [YogaKitAlignItemsViewController class]
     ];
}

- (NSArray *)demoTitleArray{
    return @[
             @"试试水而已",
             @"测试UIScrollView",
             @"FlexboxDirection布局方向",
             @"justifyContent主轴(水平)上的对齐方式",
             @"alignItems交叉轴(垂直)上的对齐方式",
             ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}



@end
