//
// WGBFlipDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/15
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
    

#import "WGBFlipDemoViewController.h"
#import "WGBFlipTransition.h"

@interface WGBFlipDemoViewController ()

@property (nonatomic, strong) WGBFlipTransition *transition;

@end

@implementation WGBFlipDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHue:(arc4random() % 256/256.0) saturation:((arc4random() % 128 / 256.0) + 0.5) brightness:((arc4random() % 128 / 256.0) + 0.5) alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 150 , 50);
    [button setTitle:@"push" forState:UIControlStateNormal];
    button.titleLabel.font = kFont(20);
    button.backgroundColor = [UIColor blackColor];
    ViewRadius(button, 25);
    [button addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];

    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(50, 200, 150 , 50);
    [button1 setTitle:@"pop" forState:UIControlStateNormal];
    button1.titleLabel.font = kFont(20);
    button1.backgroundColor = [UIColor blackColor];
    ViewRadius(button1, 25);
    [button1 addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button1];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.transition = nil;
    self.navigationController.delegate = nil;
}

- (void)pushAction{
    self.navigationController.delegate = self.transition;
    WGBFlipDemoViewController *toVC = [WGBFlipDemoViewController new];
    [self.navigationController pushViewController:toVC animated:YES];
}

- (void)popAction{
    self.navigationController.delegate = self.transition;
    [self.navigationController popViewControllerAnimated:YES];
}


- (WGBFlipTransition *)transition {
    if (!_transition) {
        _transition = [[WGBFlipTransition alloc] init];
    }
    return _transition;
}

@end
