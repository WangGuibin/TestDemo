//
// WGBMasonryHorizontalLayoutViewController.m
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
    

#import "WGBMasonryHorizontalLayoutViewController.h"

@interface WGBMasonryHorizontalLayoutViewController ()

@end

@implementation WGBMasonryHorizontalLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(120);
    }];
    
    for (NSInteger i = 0; i < 4 ; i++) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectZero];
        demoView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [bgView addSubview:demoView];
    }
    
    //水平均分布局 设定高度和竖直方向上的位置,宽度可设可不设(会根据边距和间距动态调整)  左右边距为20 中间item间距15.0
    [bgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(arc4random()%100 + 5);
        make.width.mas_equalTo(200);//就算是设置了宽度也不会生效的 !!
        make.centerY.mas_equalTo(0);
    }];
    [bgView.subviews mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:15.0 leadSpacing:20.0 tailSpacing:20.0];
    
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectZero];
    bgView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(30);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(300);
    }];
    
    for (NSInteger i = 0; i < 4 ; i++) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectZero];
        demoView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [bgView1 addSubview:demoView];
    }

    // 竖直方向上的均分布局 同理宽度或者左右边距需要设置,高度可以不设置 
    [bgView1.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(arc4random()%222);
        make.centerX.mas_equalTo(0);
    }];
    [bgView1.subviews mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedSpacing:15.0 leadSpacing:20.0 tailSpacing:20.0];

}



@end
