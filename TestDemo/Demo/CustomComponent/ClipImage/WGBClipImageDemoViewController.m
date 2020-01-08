//
// WGBClipImageDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/1/7
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
    

#import "WGBClipImageDemoViewController.h"
#import "WGBClipImageShowViewController.h"
#import "WGBClipImageContainerView.h"

@interface WGBClipImageDemoViewController ()

@property (nonatomic, strong) WGBClipImageContainerView *clipView;


@end

@implementation WGBClipImageDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100 , 30);
    [button setTitle:@"完成裁剪" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clipAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button]];    
    [self.view addSubview: self.clipView];
}

- (void)clipAction{
    WGBClipImageShowViewController * showVC = [[WGBClipImageShowViewController alloc] init];
    UIImage *img = [self.clipView.clipView getClipedResultImage];
    showVC.image = img;
    [self.navigationController pushViewController:showVC animated:YES];
}

- (WGBClipImageContainerView *)clipView {
    if (!_clipView) {
        _clipView = [[WGBClipImageContainerView alloc] initWithFrame:CGRectMake(0, 88, KWIDTH , KHIGHT - 150)];
        _clipView.originImage = [UIImage imageNamed:@"landscape.jpg"];
        _clipView.aspectRatio = 1.5;
        WGBClipBorderType borderType = (WGBClipBorderType)arc4random()%2;
        _clipView.borderType = borderType;
        _clipView.clipStyle = WGBClipStyleFrame;

    }
    return _clipView;
}

@end
