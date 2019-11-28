//
// WGBSpringAnimationDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/28
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
    

#import "WGBSpringAnimationDemoViewController.h"

@interface WGBSpringAnimationDemoViewController ()

@property (nonatomic,strong) UIView *demoView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation WGBSpringAnimationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 , 200)];
    self.demoView.backgroundColor = [UIColor orangeColor];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.demoView.centerX = self.bgView.width/2.0;
    self.demoView.centerY = self.bgView.height/2.0;
}


- (IBAction)show:(UIButton *)sender {
    self.demoView.alpha = 0.01;
    self.demoView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.bgView addSubview:self.demoView];

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.demoView.transform = CGAffineTransformIdentity;
         self.demoView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

}

- (IBAction)exitAction:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.demoView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.demoView.alpha = 0.01;
    } completion:^(BOOL finished) {
        self.demoView.transform = CGAffineTransformIdentity;
        [self.demoView removeFromSuperview];
    }];
}

@end
