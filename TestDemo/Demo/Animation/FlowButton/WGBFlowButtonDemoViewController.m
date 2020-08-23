//
// WGBFlowButtonDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/23
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
    

#import "WGBFlowButtonDemoViewController.h"
#import "WGBAnimationFlowButton.h"

@interface WGBFlowButtonDemoViewController ()

@end

@implementation WGBFlowButtonDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    WGBAnimationFlowButton *flowButton = [[WGBAnimationFlowButton alloc] initWithFrame:CGRectZero];
    flowButton.button.backgroundColor = [UIColor systemPinkColor];
    flowButton.layer.cornerRadius = 20;
    flowButton.layer.masksToBounds = YES;
    flowButton.animationInterval = 2.0f;
    flowButton.flowBgColor = [UIColor whiteColor];
    [self.view addSubview:flowButton];
    [flowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.size.mas_equalTo(CGSizeMake(300, 100));
        make.centerX.mas_equalTo(0);
    }];
    
    WGBAnimationFlowButton *flowButton1 = [[WGBAnimationFlowButton alloc] initWithFrame:CGRectMake(80, 350, 200 , 50)];
    flowButton1.layer.cornerRadius = 20;
    flowButton1.layer.masksToBounds = YES;
    flowButton1.flowBgColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    [self.view addSubview:flowButton1];
    
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
