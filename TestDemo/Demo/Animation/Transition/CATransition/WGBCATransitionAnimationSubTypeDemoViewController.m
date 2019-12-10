//
// WGBCATransitionAnimationSubTypeDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/10
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
    

#import "WGBCATransitionAnimationSubTypeDemoViewController.h"
#import "WGBTestCATransitionDemoViewController.h"

@interface WGBCATransitionAnimationSubTypeDemoViewController ()

@end

@implementation WGBCATransitionAnimationSubTypeDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBTestCATransitionDemoViewController class],
        [WGBTestCATransitionDemoViewController class],
        [WGBTestCATransitionDemoViewController class],
        [WGBTestCATransitionDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"上",
        @"下",
        @"左",
        @"右"
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = self.demoClassArray[indexPath.row];
    NSString *title = self.demoTitleArray[indexPath.row];
    WGBTestCATransitionDemoViewController *vc = (WGBTestCATransitionDemoViewController *)[[cls alloc] init];
    vc.navigationItem.title = [NSString stringWithFormat:@"%@%@",self.navigationItem.title,title];
    WGBTransitionAnimationSubType subType ;
    if (indexPath.row == 0) {
        subType = WGBTransitionAnimationSubTypeFromTop;
    }else if (indexPath.row == 1) {
        subType = WGBTransitionAnimationSubTypeFromBottom;
    }else if (indexPath.row == 2) {
        subType = WGBTransitionAnimationSubTypeFromLeft;
    }else {
        subType = WGBTransitionAnimationSubTypeFromRight;
    }
    CATransition *transition = [CATransition wgb_createTransitionWithAnimationType:self.animationType subType:subType duration:1.0];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
