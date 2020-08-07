//
// WGBHover2ViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/7
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
    

#import "WGBHover2ViewController.h"
#define kHeaderHeight 300
#define kSectionHeaderHeignt 44
#define kTopHeight (kHeaderHeight + kSectionHeaderHeignt)

@interface WGBHover2ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL isHover;//是否悬停
@property (nonatomic, strong) UIView *sectionHeaderView;

@end

@implementation WGBHover2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHover = YES;//默认悬停
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *hoverSwitch = [[UISwitch alloc] init];
    [hoverSwitch addTarget:self action:@selector(changeHoverState:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hoverSwitch];
    [self.tableView reloadData];
    self.tableView.contentInset = UIEdgeInsetsMake(kTopHeight, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -kTopHeight)];
    
    //默认悬停
    hoverSwitch.on = self.isHover;
    [self.view addSubview:self.headerView];
    [self.view bringSubviewToFront:self.headerView];
    self.headerView.frame = CGRectMake(0, kNavBarHeight, KWIDTH , kHeaderHeight);
    
    [self.view addSubview:self.sectionHeaderView];
    [self.view bringSubviewToFront:self.sectionHeaderView];
    self.sectionHeaderView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KWIDTH , kSectionHeaderHeignt);
}

- (void)changeHoverState:(UISwitch *)sw{
    self.isHover = sw.on;
    [MBProgressHUD showText:sw.on?  @"已开启悬停" : @"已关闭悬停" afterDelay:1];
    if (self.isHover) {
        [self.view addSubview:self.headerView];
        [self.view bringSubviewToFront:self.headerView];
        self.headerView.frame = CGRectMake(0, kNavBarHeight, KWIDTH , kHeaderHeight);
        
        [self.view addSubview:self.sectionHeaderView];
        [self.view bringSubviewToFront:self.sectionHeaderView];
        self.sectionHeaderView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KWIDTH , kSectionHeaderHeignt);
    }else{
        [self.tableView addSubview:self.headerView];
        self.headerView.frame = CGRectMake(0, -kTopHeight, KWIDTH , kHeaderHeight);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.tableView.bounces = offsetY > 0;
    if (!self.isHover) {
        CGFloat tempY = offsetY + kTopHeight;
        CGFloat alpha = 1 - ((kTopHeight - tempY)/kTopHeight);
        UIImage *image = [UIImage createImageWithColor:[[UIColor cyanColor] colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

        if (offsetY >= -kTopHeight) {
            if (offsetY < 0) {
                [self.view addSubview:self.sectionHeaderView];
                [self.view bringSubviewToFront:self.sectionHeaderView];
                CGFloat sectionY = MAX(kNavBarHeight, ABS(offsetY)+kSectionHeaderHeignt);
                self.sectionHeaderView.frame = CGRectMake(0,sectionY, KWIDTH , kSectionHeaderHeignt);
            }
        }else{
            [self.tableView bringSubviewToFront:self.sectionHeaderView];
            self.sectionHeaderView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KWIDTH , kSectionHeaderHeignt);
        }
    }else{
        [self.tableView bringSubviewToFront:self.sectionHeaderView];
        self.sectionHeaderView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KWIDTH , kSectionHeaderHeignt);
    }
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *sectionBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 44.0f)];
//    sectionBg.backgroundColor = [UIColor orangeColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH-40 , 44)];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"全部评论(666)";
//    [sectionBg addSubview:label];
//    return sectionBg;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0 , 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0 , 0.001)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kNavBarHeight);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , kHeaderHeight)];
        _headerView.backgroundColor = [UIColor blackColor];
    }
    return _headerView;
}

- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , kSectionHeaderHeignt)];
        _sectionHeaderView.backgroundColor = [UIColor orangeColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH-40 , kSectionHeaderHeignt)];
        label.textColor = [UIColor whiteColor];
        label.text = @"全部评论(666)";
        [_sectionHeaderView addSubview:label];
    }
    return _sectionHeaderView;
}

@end
