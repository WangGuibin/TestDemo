//
// WGBWeixinDemoTestViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/22
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
    

#import "WGBWeixinDemoTestViewController.h"
#import "WGBWeixinDemoTestToViewController.h"

@interface WGBWeixinDemoTestViewController ()

@property (nonatomic, strong) UIImageView *demoView;

@end

@implementation WGBWeixinDemoTestViewController

///MARK:- <WGBInteractionMotionTransitionDelegate>
- (UIView *)wgb_animationView{
    return self.demoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.demoView.frame = CGRectMake(0, KHIGHT - 100, 100 , 100);
    self.demoView.userInteractionEnabled = YES;
    @weakify(self);
    [self.demoView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable gestureRecoginzer) {
        @strongify(self);
       //转场
        WGBWeixinDemoTestToViewController *toVC = [WGBWeixinDemoTestToViewController new];
        self.navigationController.delegate = toVC;
        [self.navigationController pushViewController:toVC animated:YES];        
    }];
}


- (UIImageView *)demoView {
    if (!_demoView) {
        _demoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _demoView.backgroundColor = [UIColor blackColor];
        _demoView.image = [UIImage imageNamed:@"landscape"];
//        _demoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_demoView];
    }
    return _demoView;
}


@end
