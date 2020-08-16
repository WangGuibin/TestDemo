//
// WGBMasonryItemFlexedLayoutViewController.m
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
    

#import "WGBMasonryItemFlexedLayoutViewController.h"

@interface WGBMasonryItemFlexedLayoutViewController ()

@end

@implementation WGBMasonryItemFlexedLayoutViewController

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
    
    ///水平均匀分布排列  保证每个item水平方向上的长度都是固定大小,高度可以自由设置 间距自动调整 边距是设置好的
    CGFloat itemW = arc4random()%80;
    [bgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(itemW, arc4random()%120));
    }];
    [bgView.subviews mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:itemW leadSpacing:20 tailSpacing:20];
    
    
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

    ///竖直方向上均匀分布排列  保证每个item竖直方向上的长度都是固定大小,宽度可以自由设置 间距自动调整 边距是设置好的
    [bgView1.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(arc4random()%300);
        make.centerX.mas_equalTo(0);
    }];
    [bgView1.subviews mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedItemLength:60 leadSpacing:20 tailSpacing:20];
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
