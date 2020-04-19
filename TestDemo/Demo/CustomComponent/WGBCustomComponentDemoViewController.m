//
// WGBCustomComponentDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/19
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
    

#import "WGBCustomComponentDemoViewController.h"
#import "WGBFancyQRCodeToolDemoViewController.h"
#import "WGBSelectImagesDemoViewController.h"
#import "WGBGradientProgressDemoViewController.h"
#import "WGBColorSliderPickerDemoViewController.h"
#import "WGBWaveLayerButtonDemoViewController.h"
#import "WGBEasyMarqueeViewDemoViewController.h"
#import "WGBDIYScanQRCodeDemoViewController.h"
#import "WGBColorChangeDemoViewController.h"
#import "WGBCreateQRCodeDemoViewController.h"
#import "WGBClipImageDemoViewController.h"
#import "WGBAspectFitImageBrowerViewController.h"

@interface WGBCustomComponentDemoViewController ()

@end

@implementation WGBCustomComponentDemoViewController
- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBCreateQRCodeDemoViewController class],
        [WGBFancyQRCodeToolDemoViewController class],
        [WGBSelectImagesDemoViewController class],   
        [WGBGradientProgressDemoViewController class],
        [WGBColorSliderPickerDemoViewController class],
        [WGBWaveLayerButtonDemoViewController class], 
        [WGBEasyMarqueeViewDemoViewController class],
        [WGBDIYScanQRCodeDemoViewController class],
        [WGBColorChangeDemoViewController class],
        [WGBClipImageDemoViewController class],
        [WGBAspectFitImageBrowerViewController class]
    ];
}

- (NSArray *)demoTitleArray{
    return @[
        @"创建二维码和条形码",
        @"花式二维码",
        @"选择相册-发布",
        @"渐变进度条Demo",
        @"颜色选择控件",
        @"WGBWaveLayerButton涟漪按钮",
        @"WGBEasyMarqueeVie跑马灯实践",
        @"DIY扫描二维码",
        @"loading && 颜色过渡算法",
        @"图片裁剪",
        @"图片组自适应大小浏览左右切换"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}


@end
