//
// WGBTestHoleDemoViewController.m
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
    

#import "WGBTestHoleDemoViewController.h"
#import "WGBTestCATransitionDemoViewController.h"
#import "WGBHoleAnimatedTransitioning.h"

@interface WGBTestHoleDemoViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) WGBHoleAnimatedTransitioning *animatedTransitioning;

@end

@implementation WGBTestHoleDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 50 , 50);
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    button.titleLabel.font = kFont(12);
    button.backgroundColor = [UIColor blackColor];
    ViewRadius(button, 25);
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.animatedTransitioning = nil;
}

- (void)clickAction{
    WGBTestCATransitionDemoViewController *testVC = [WGBTestCATransitionDemoViewController new];
    testVC.transitioningDelegate = self;
    testVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:testVC animated:YES completion:^{
        
    }];
}

///MARK:- <UIViewControllerTransitioningDelegate>
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animatedTransitioning;
}

- (WGBHoleAnimatedTransitioning *)animatedTransitioning {
    if (!_animatedTransitioning) {
        _animatedTransitioning = [[WGBHoleAnimatedTransitioning alloc] init];
        _animatedTransitioning.entranceFrame = CGRectMake(50, 100, 50 , 50);
    }
    return _animatedTransitioning;
}

@end
