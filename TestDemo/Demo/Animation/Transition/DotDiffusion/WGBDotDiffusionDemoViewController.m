//
// WGBDotDiffusionDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/20
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
    

#import "WGBDotDiffusionDemoViewController.h"
#import "WGBDotDiffusionDemoDetailViewController.h"

@interface WGBDotDiffusionDemoViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIButton *presentButton;
@property (nonatomic,strong)  UIImageView *bgImageView ;

@end

@implementation WGBDotDiffusionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
     [self.view addSubview:self.presentButton];
    ViewRadius(self.presentButton, 20);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.presentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-80);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

#pragma mark - 点击事件
-(void)persentAction:(UIButton *)button {
    // 充当渐变的背景(可以用自定义view代替) 转场里一般使用截图 应该和目标VC是同一个图片 视觉假象
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape.jpg"]];
    bgImageView.frame = self.view.frame;
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    // 
    //动画
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:button.frame];
    CGFloat radius = [UIScreen mainScreen].bounds.size.height - 100;
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    maskLayer.backgroundColor = (__bridge CGColorRef)([UIColor whiteColor]);
    bgImageView.layer.mask = maskLayer;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    // 时间
    maskLayerAnimation.duration = 1.0;
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

/// 结束事件
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    WGBDotDiffusionDemoDetailViewController *showVC = [[WGBDotDiffusionDemoDetailViewController alloc] init];
//    showVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:showVC animated:NO completion:nil];
    [self.navigationController pushViewController:showVC animated:NO];
    [self.bgImageView removeFromSuperview];
}

/// 开始事件
-(void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"开始动画");
}

#pragma mark - Get方法
-(UIButton *)presentButton {
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentButton.frame = CGRectMake(0, 0, 100, 40);
        _presentButton.center = self.view.center;
        _presentButton.backgroundColor = [UIColor blackColor];
        [_presentButton setTitle:@"下一页" forState:UIControlStateNormal];
        [_presentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_presentButton addTarget:self action:@selector(persentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _presentButton;
}

@end
