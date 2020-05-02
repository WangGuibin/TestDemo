//
// WGBScrollTrackingViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/4/29
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
    

#import "WGBScrollTrackingViewController.h"
#import "WGBAttentionListHeaderView.h"
#import "WGBTestTableListDataDemoSubVC.h"

@interface WGBScrollTrackingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WGBAttentionListHeaderView *headerView;
@property (nonatomic, strong) WGBTestTableListDataDemoSubVC *attentionListVC;
@property (nonatomic, strong) WGBTestTableListDataDemoSubVC *fansListVC;

@end

@implementation WGBScrollTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self addChildVCs];
    
}

- (void)setup{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavBarHeight);
        make.height.mas_equalTo(50);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
        
    @weakify(self);
    [self.headerView setClickButtonActionBlock:^(NSInteger index) {
       @strongify(self);
        [self scrollToIndex: index animated:YES];
    }];
}


- (void)addChildVCs{
    [self.view layoutIfNeeded];
    //关注
    [self.scrollView addSubview: self.attentionListVC.view];
    self.attentionListVC.view.frame = CGRectMake(0, 0, KWIDTH, self.scrollView.height);
    [self addChildViewController:  self.attentionListVC];
    
    //粉丝
    [self.scrollView addSubview: self.fansListVC.view];
    self.fansListVC.view.frame = CGRectMake(KWIDTH, 0, KWIDTH, self.scrollView.height);
    [self addChildViewController: self.fansListVC];

    self.scrollView.contentSize = CGSizeMake(KWIDTH*self.childViewControllers.count, self.scrollView.height);
    //默认选中
    self.headerView.defaultSelectIndex = 0;
    [self scrollToIndex: 0 animated:NO];
}

/// 滚动到某一下标
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(KWIDTH*index, 0) animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = scrollView.contentOffset.x/KWIDTH;
        if (self.headerView.defaultSelectIndex != index) {
            self.headerView.defaultSelectIndex = index;
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}



- (WGBAttentionListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WGBAttentionListHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 50)];
        [self.view addSubview: _headerView];
        
    }
    return _headerView;
}


- (WGBTestTableListDataDemoSubVC *)attentionListVC {
    if (!_attentionListVC) {
        _attentionListVC = [[WGBTestTableListDataDemoSubVC alloc] init];
    }
    return _attentionListVC;
}


- (WGBTestTableListDataDemoSubVC *)fansListVC {
    if (!_fansListVC) {
        _fansListVC = [[WGBTestTableListDataDemoSubVC alloc] init];
    }
    return _fansListVC;
}

@end
