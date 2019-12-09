//
// AlertDemoViewController.m
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
    

#import "AlertDemoViewController.h"
#import "WGBCustomPopUpDemoViewController.h"
#import "FSPopDialogViewControllerDemoViewController.h"
#import "WGBCommonAlertSheetViewDemoViewController.h"
#import "WGBMaskDemoViewController.h"
#import "PopverDemoViewController.h"
#import "WGBPresentAlertDemoViewController.h"

@interface AlertDemoViewController ()

@end

@implementation AlertDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBCustomPopUpDemoViewController class],  
        [FSPopDialogViewControllerDemoViewController class],
        [WGBCommonAlertSheetViewDemoViewController class],
        [WGBMaskDemoViewController class],
        [PopverDemoViewController class],
        [WGBPresentAlertDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"WGBCustomPopUpView",
        @"FSPopDialogVC Demo",
        @"WGBCommonAlertSheetView仿抖音评论",
        @"mask使用",
        @"系统`UIPopoverPresentationController`带箭头弹窗",
        @"利用VC present转场做弹窗"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

@end
