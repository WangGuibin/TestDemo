//
// WGBCustomWindowDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/26
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
    

#import "WGBCustomWindowDemoViewController.h"
#import "WGBCustomWindow.h"

@interface WGBCustomWindowDemoViewController ()


@end

@implementation WGBCustomWindowDemoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 200 , 50);
    [button setTitle:@"展示/取消" forState:UIControlStateNormal];
    button.titleLabel.font = kFont(12);
    button.backgroundColor = [UIColor blackColor];
    ViewRadius(button, 25);
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];

}

- (void)clickAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
       UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
        redView.backgroundColor = [UIColor redColor];
        ViewRadius(redView, 40);
        redView.userInteractionEnabled = YES;
        [redView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable gestureRecoginzer) {
            [WGBAlertTool showSignatureInputAlertWithCallBack:^(NSString * _Nonnull signature) {
                NSLog(@"signature: %@",signature);
            }];
        }];
        [WGBCustomWindow shareInstanceWindow].contentView = redView;
        [[WGBCustomWindow shareInstanceWindow] show];
    }else{
        [[WGBCustomWindow shareInstanceWindow] dismiss];
    }
}


@end
