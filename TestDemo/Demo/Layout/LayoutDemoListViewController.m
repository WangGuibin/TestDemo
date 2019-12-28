//
// LayoutDemoListViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/18
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
    

#import "LayoutDemoListViewController.h"
#import "WGBRepairedOrientationLabelDemoViewController.h"
#import "NSLayoutAnchorDemoViewController.h"
#import "YYTextDemoViewController.h"
#import "YogaKitDemoViewController.h"
#import "WGBShowCollectionLayoutListDemoViewController.h"
#import "WGBHighLightLabelViewController.h"
#import "WGBFloatViewDemoViewController.h"
#import "WGBDrawGridViewDemoViewController.h"
#import "WGBGradientTextDemoViewController.h"


@interface LayoutDemoListViewController ()

@end

@implementation LayoutDemoListViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBRepairedOrientationLabelDemoViewController class], 
        [NSLayoutAnchorDemoViewController class],
        [YYTextDemoViewController class],
        [YogaKitDemoViewController class],
        [WGBShowCollectionLayoutListDemoViewController class],
        [WGBHighLightLabelViewController class],
        [WGBFloatViewDemoViewController class],
        [WGBDrawGridViewDemoViewController class],
        [WGBGradientTextDemoViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"WGBRepairedOrientationLabel",
        @"iOS 布局约束`NSLayoutAnchor`学习",
        @"YYTextDemoViewController测试学习",
        @"YogaKit Demo (FlexBox布局)",
        @"collectionView布局",
        @"UILabel高亮文字点击",
        @"类似苹果的小圆点---漂浮的View",
        @"绘制网格",
        @"渐变文字实现方式"
    ];
}

//NSInteger pageNum = (NSInteger)scrollView.contentOffset.x / (NSInteger)MSWIDTH;
//NSInteger remainder1 = (NSInteger)scrollView.contentOffset.x % (NSInteger)MSWIDTH;
//if (remainder1 > MSWIDTH/2) {
//    pageNum = pageNum + 1;
//}
//if (self.currentPage != pageNum) {
//    self.currentPage = pageNum;
//    self.pageCtrl.currentPage = pageNum;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

@end
