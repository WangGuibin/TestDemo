//
// WGBBounceEffectButtonDemoVC.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2023/5/4
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
    

#import "WGBBounceEffectButtonDemoVC.h"
#import "DHBounceView.h"

@interface WGBBounceEffectButtonDemoVC ()

@end

@implementation WGBBounceEffectButtonDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    DHBounceView * bounceView = [[DHBounceView alloc] initWithContentsFrame:CGRectMake(220, 80, 120, 40) interval:10];
    bounceView.clickAction = ^(DHBounceView * bounceView) {
    
        [[[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
    
    };
    [self.view addSubview:bounceView];
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"bg.jpg"].CGImage;
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVibrancyEffect * vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = bounceView.bounds;
    [bounceView addSubview:effectView];
    
    UIVisualEffectView * vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    vibrancyEffectView.frame = effectView.bounds;
    [effectView.contentView addSubview:vibrancyEffectView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:bounceView.privateContentsFrame];
    label.text = @"登录";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    
    [vibrancyEffectView.contentView addSubview:label];
}



@end
