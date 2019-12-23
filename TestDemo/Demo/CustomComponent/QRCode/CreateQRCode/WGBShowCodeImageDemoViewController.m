//
// WGBShowCodeImageDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/23
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
    

#import "WGBShowCodeImageDemoViewController.h"
#import "WGBGradientCodeView.h"
#import "WGBCreateQRCodeTool.h"

@interface WGBShowCodeImageDemoViewController ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UIImageView *barCodeImageView;
@property (nonatomic, strong) WGBGradientCodeView *gradientCodeImageView;

@end

@implementation WGBShowCodeImageDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.QRTitle;
    if (self.type == 0) {
        self.qrCodeImageView.image = [WGBCreateQRCodeTool qrCodeImageWithContent:@"http://www.baidu.com" codeImageSize:200];
         [self.view addSubview:self.qrCodeImageView];
    }else if (self.type == 1){
        self.barCodeImageView.image = [WGBCreateQRCodeTool barcodeImageWithContent:@"66666666" codeImageSize:CGSizeMake(200, 90)];
        [self.view addSubview:self.barCodeImageView];
    }else if (self.type == 2){
        self.qrCodeImageView.image = [WGBCreateQRCodeTool qrCodeImageWithContent:@"http://www.baidu.com" codeImageSize:200 logo:[UIImage imageNamed:@"cat.jpg"] logoFrame:CGRectMake(75, 75, 50, 50) red:1.0 green:0 blue:0];
        [self.view addSubview:self.qrCodeImageView];
    }else if (self.type == 3){
        self.barCodeImageView.image = [WGBCreateQRCodeTool barcodeImageWithContent:@"6666666" codeImageSize:CGSizeMake(200, 90) red:1.0 green:0 blue:0];
        [self.view addSubview:self.barCodeImageView];
    }else if (self.type == 4){
        UIImage * image = [WGBCreateQRCodeTool qrCodeImageWithContent:@"http://www.baidu.com" codeImageSize:200];
        [self.gradientCodeImageView  syncFrame];
        [self.gradientCodeImageView setQRCodeImage:image];
        [self.view addSubview:self.gradientCodeImageView];
    }
}


- (UIImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] initWithImage:nil];
        _qrCodeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _qrCodeImageView.clipsToBounds = YES;
        _qrCodeImageView.frame = CGRectMake(KWIDTH/2.0 - 100, KWIDTH/2.0 - 100, 200, 200);
    }
    return _qrCodeImageView;
}

- (UIImageView *)barCodeImageView {
    if (!_barCodeImageView) {
        _barCodeImageView = [[UIImageView alloc] initWithImage:nil];
        _barCodeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _barCodeImageView.clipsToBounds = YES;
        _barCodeImageView.frame =CGRectMake(KWIDTH/2.0 - 100, KWIDTH/2.0 - 100, 200, 90);
    }
    return _barCodeImageView;
}


- (WGBGradientCodeView *)gradientCodeImageView {
    if (!_gradientCodeImageView) {
        _gradientCodeImageView = [[WGBGradientCodeView alloc] initWithFrame:CGRectZero];
        _gradientCodeImageView.frame = CGRectMake(KWIDTH/2.0 - 100, KWIDTH/2.0 - 100, 200, 200);
    }
    return _gradientCodeImageView;
}

@end
