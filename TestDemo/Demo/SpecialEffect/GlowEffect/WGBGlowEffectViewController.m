//
// WGBGlowEffectViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/23
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
    

#import "WGBGlowEffectViewController.h"
#import "UIView+GlowView.h"

@interface WGBGlowEffectViewController ()



@end

@implementation WGBGlowEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    {
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.text      = @"辉光效果啊";
        label.textColor = [UIColor blackColor];
        label.font      = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:20.f];
        label.center    = self.view.center;
        [self.view addSubview:label];
        
        label.glowRadius        = @(10.f);
        label.glowOpacity       = @(1.f);
        label.glowColor         = [UIColor redColor];
        
        label.glowDuration          = @(0.25);
        label.hideDuration          = @(0.15f);
        label.glowAnimationDuration = @(0.2f);
        
        [label createGlowLayer];
        [label insertGlowLayer];
        [label startGlowLoop];
    }
    
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 350, 50, 50)];
        imageView.image        = [UIImage imageNamed:@"icon_big_sex_boy_sel"];
        [self.view addSubview:imageView];
        
        imageView.glowRadius        = @(2.f);
        imageView.glowOpacity       = @(0.5f);
        imageView.glowColor         = [UIColor greenColor];
        
        imageView.glowDuration          = @(1.f);
        imageView.hideDuration          = @(0.5f);
        imageView.glowAnimationDuration = @(1.f);
        
        [imageView createGlowLayer];
        [imageView insertGlowLayer];
        [imageView startGlowLoop];
    }
}
@end
