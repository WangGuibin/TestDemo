//
// WGBTransitionDemoListViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/6
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
    

#import "WGBTransitionDemoListViewController.h"
#import "PushPopSimpleDemoFromViewController.h"
#import "WGBCATransitionAnimationTypeDemoViewController.h"
#import "WGBTestHoleDemoViewController.h"
#import "WGBDropDownTestDemoViewController.h"

@interface WGBTransitionDemoListViewController ()

@end

@implementation WGBTransitionDemoListViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [PushPopSimpleDemoFromViewController class],
        [WGBCATransitionAnimationTypeDemoViewController class],
        [WGBTestHoleDemoViewController class],
        [WGBDropDownTestDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"基本操作-简称基操",
        @"CATransition转场",
        @"管中窥豹-以点到面(有点bug)",
        @"下拉转场"
    ];
}

//UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIView.AnimationOptions.curveEaseInOut, animations: ({
//    // do stuff
//}), completion: nil)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

@end
