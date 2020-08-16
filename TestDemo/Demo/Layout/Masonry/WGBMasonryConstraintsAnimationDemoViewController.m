//
// WGBMasonryConstraintsAnimationDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/16
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
    

#import "WGBMasonryConstraintsAnimationDemoViewController.h"

@interface WGBMasonryConstraintsAnimationDemoViewController ()

@property (nonatomic, assign) BOOL animationFlag;//为了取反
@property (nonatomic, strong) UIView *bgView;


@end

@implementation WGBMasonryConstraintsAnimationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.animationFlag = NO;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor cyanColor];
    bgView.layer.cornerRadius = 10.0f;
    bgView.layer.masksToBounds = YES;
    bgView.alpha = 0.0;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    self.bgView = bgView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blackColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:@"click" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    [button.titleLabel setContentCompressionResistancePriority:(UILayoutPriorityRequired) forAxis:(UILayoutConstraintAxisHorizontal)];
    [button addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];    
}


- (void)changeAction{
    self.animationFlag = !self.animationFlag;

    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        
        if (self.animationFlag) {
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(50);
                make.width.mas_equalTo(KWIDTH-100);
                make.height.mas_equalTo(200);
            }];
            self.bgView.alpha = 1.0;
        }else{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(0);
            }];
            self.bgView.alpha = 0.0;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
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
