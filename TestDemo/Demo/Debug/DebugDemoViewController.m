//
// DebugDemoViewController.m
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
    

#import "DebugDemoViewController.h"
#import "VCTimeProfilerViewController.h"
#import "ZombieTestViewController.h"
#import "AppFluencyMonitorTestViewController.h"
#import "NetDiagnoServiceDemoViewController.h"

@interface DebugDemoViewController ()

@end

@implementation DebugDemoViewController
- (NSArray<Class> *)demoClassArray{
    return @[
        [VCTimeProfilerViewController class],
        [ZombieTestViewController class],
        [AppFluencyMonitorTestViewController class],
        [NetDiagnoServiceDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"页面耗时统计",
        @"野指针检测",
        @"卡顿检测",
        @"网络诊断"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

@end
