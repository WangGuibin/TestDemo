//
// WGBHighLightLabelViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/7
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
    

#import "WGBHighLightLabelViewController.h"
#import "UILabel+WGBStringAction.h"

@interface WGBHighLightLabelViewController ()



@end

@implementation WGBHighLightLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testCode];
    
}

- (void)testCode{
    CGRect frame = CGRectMake(0, 150, KWIDTH, 60);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:label];
    label.text = @"baidu.com 哈哈 google.com哈 哈,xxxx.com";
    label.tapHighlightedColor = [UIColor clearColor];//颜色位置显示不太对 所以干脆不让它显示
    NSArray *strings = @[@"baidu.com", @"google.com", @"xxxx.com"];
    [label wgb_addAttributeTapActionWithStrings:strings tapClicked:^(UILabel * _Nonnull label, NSString * _Nonnull string, NSRange range, NSInteger index) {
        NSLog(@"string: %@, range:%lu", string, (unsigned long)range.length);
        [MBProgressHUD showText:[NSString stringWithFormat:@"%ld - %@",index,string]];
    }];

}

@end
