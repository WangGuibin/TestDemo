//
// WGBTestMenuViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/11
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
    

#import "WGBTestMenuViewController.h"
#import "WGBSlideMenuViewController.h"
#import "WGBTestSlideDemoViewController.h"

@interface WGBTestMenuViewController ()

@end

@implementation WGBTestMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 150 , 30);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    
}


- (void)clickAction{
    //presentedViewController 弹出此控制器的源控制器或者距离此控制器最远的起始控制器
    //presentingViewController 弹出此控制器的源控制器或者距离此控制器最近的起始控制器
//    https://www.jianshu.com/p/4070131158e5
    if (self.presentingViewController) {//判断是present出来的依据
        CATransition *transition = [CATransition wgb_createTransitionWithAnimationType:(WGBTransitionAnimationTypePrivatePageUnCurl) subType:(WGBTransitionAnimationSubTypeFromTop) duration:0.5];
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        return;
    }
    WGBSlideMenuViewController *menuVC = [WGBSlideMenuViewController controllerWithViewController:[WGBTestMenuViewController new] sidebarViewController:[WGBTestSlideDemoViewController new]];
    menuVC.view.backgroundColor = [UIColor orangeColor];
    [self presentViewController:menuVC animated:YES completion:^{
        
    }];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
