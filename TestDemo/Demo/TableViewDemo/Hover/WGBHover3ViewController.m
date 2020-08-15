//
// WGBHover3ViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/15
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
    

#import "WGBHover3ViewController.h"

/// 在结合方式①和方式②的基础上修改的 粗略仿一下哔哩哔哩播放详情页的交互

#define kVideoHeight 300
#define kContentHeight 100
#define kHeaderHeight (kVideoHeight+kContentHeight)
#define kSectionHeaderHeignt 44


@interface WGBHover3ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView; //头部跟随滚动
@property (nonatomic, strong) UIView *videoView;//视频播放器的容器
@property (nonatomic, strong) UIView *contentView;//文本/描述/简介等等一些视频的信息
@property (nonatomic, strong) UIView *sectionHeaderView;//全部评论(99+) 悬停

@property (nonatomic, assign) BOOL isHover;//是否悬停

@end

@implementation WGBHover3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHover = YES;//默认悬停
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *hoverSwitch = [[UISwitch alloc] init];
    [hoverSwitch addTarget:self action:@selector(changeHoverState:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hoverSwitch];
    hoverSwitch.on = self.isHover;
    [self changeHoverState:hoverSwitch];//主动调用一次
}

- (void)changeHoverState:(UISwitch *)sw{
    self.isHover = sw.on;
    [MBProgressHUD showText:sw.on?  @"已开启悬停" : @"已关闭悬停" afterDelay:1];
    if (self.isHover) {
        [self.view addSubview:self.videoView];
        self.videoView.frame = CGRectMake(0, kNavBarHeight, KWIDTH , kVideoHeight);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.videoView.frame), KWIDTH , KHIGHT - kNavBarHeight - kVideoHeight - kBottomHeight);
        self.contentView.frame = CGRectMake(0, 0, KWIDTH , kContentHeight);
    }else{
        [self.headerView addSubview: self.videoView];
        self.tableView.frame = CGRectMake(0, kNavBarHeight, KWIDTH , KHIGHT - kNavBarHeight - kBottomHeight);
        self.videoView.frame = CGRectMake(0, 0, KWIDTH , kVideoHeight);
        self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.videoView.frame), KWIDTH , kContentHeight);
        self.tableView.contentOffset = CGPointZero;
    }
    
    self.headerView.height = CGRectGetMaxY(self.contentView.frame);
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.tableView.bounces = offsetY >= kHeaderHeight;
    if (!self.isHover) {
        CGFloat totalHeight = kNavBarHeight + kHeaderHeight;
        CGFloat alpha = 1 - ((totalHeight - offsetY)/totalHeight);
        UIImage *image = [UIImage createImageWithColor:[[UIColor cyanColor] colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeignt;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview: _tableView];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , kHeaderHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}


- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoView.backgroundColor = [UIColor blackColor];
    }
    return _videoView;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor brownColor];
        [self.headerView addSubview:_contentView];
    }
    return _contentView;
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
