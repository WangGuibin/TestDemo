//
// WGBMasonryScrollViewDemoViewController.m
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
    

#import "WGBMasonryScrollViewDemoViewController.h"

@interface WGBMasonryScrollViewDemoViewController ()

@end

@implementation WGBMasonryScrollViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(120);
    }];

    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:contentView];
    ///!! 关键是容器的约束布局
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView); //固定高度 水平滚动
    }];
    
    
    for (NSInteger i = 0; i < 14 ; i++) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectZero];
        demoView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [contentView addSubview:demoView];
    }
    
    //水平均分布局 设定高度和竖直方向上的位置,宽度可设可不设(会根据边距和间距动态调整)  左右边距为20 中间item间距15.0
    [contentView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(arc4random()%100 + 5);
        make.width.mas_equalTo(200);//就算是设置了宽度也不会生效的 !!
        make.centerY.mas_equalTo(0);
    }];
    [contentView.subviews mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:15.0 leadSpacing:20.0 tailSpacing:20.0];
    
    //////////////////////////////////////////////
    
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:scrollView1];
    [scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).offset(30);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(500);
    }];

    
    UIView *contentView1 = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView1 addSubview:contentView1];
    ///!! 关键是容器的约束布局
    [contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView1);
        make.width.equalTo(scrollView1); //固定宽度 垂直滚动
    }];
    
    
    for (NSInteger i = 0; i < 14 ; i++) {
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectZero];
        demoView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        [contentView1 addSubview:demoView];
    }
    
    //垂直均分布局
    [contentView1.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(300);
        make.centerX.mas_equalTo(0);
    }];
    [contentView1.subviews mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedSpacing:15.0 leadSpacing:20.0 tailSpacing:20.0];
    
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
