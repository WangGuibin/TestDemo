//
// TableViewDemoViewController.m
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
    

#import "TableViewDemoViewController.h"
#import "TableViewCustomDeleteButtonDemoViewController.h"
#import "TableViewMultipleSelectionDemoViewController.h"
#import "TableViewSigleSelectionViewController.h"
#import "WGBPreLoadDataLogicDemoViewController.h"
#import "WGBAOPTableViewDemoViewController.h"
#import "WGBDotLineCellDemoViewController.h"
#import "WGBHoverViewController.h"
#import "WGBHover2ViewController.h"
#import "WGBHover3ViewController.h"

#import "WGBRefreshDemo1ViewController.h"
#import "WGBRefreshDemo2ViewController.h"

@interface TableViewDemoViewController ()

@end

@implementation TableViewDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [TableViewMultipleSelectionDemoViewController class],
        [TableViewSigleSelectionViewController class],
        [TableViewCustomDeleteButtonDemoViewController class],
        [WGBPreLoadDataLogicDemoViewController class],
        [WGBAOPTableViewDemoViewController class],
        [WGBDotLineCellDemoViewController class],
        [WGBHoverViewController class],
        [WGBHover2ViewController class],
        [WGBHover3ViewController class],
        [WGBRefreshDemo1ViewController class],
        [WGBRefreshDemo2ViewController class]
     ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"tableView多选",
        @"tableView单选",
        @"tableView自定义删除按钮",
        @"智能预加载基本逻辑",
        @"AOP切面编程",
        @"点连成线的进度节点cell",
        @"控制tableView滚动悬停①",
        @"控制tableView滚动悬停②",
        @"粗略模仿哔哩哔哩播放详情页的交互",
        @"自定义刷新控件的原理",
        @"下拉展开查看图片,上推自动吸顶"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}
@end
