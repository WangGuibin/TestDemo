//
// WGBHoverViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/6
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
    

#import "WGBHoverViewController.h"

///< 仿哔哩哔哩的播放悬停,暂停可上推 实现原理
/// 项目中要比这复杂得多 它的交互是这样的:
/// 1.播放过程中,播放器悬浮在屏幕最上层,不跟随滚动,评论数量(sectionHeader)要悬停在视频底部
/// 但是 sectionHeader上面还得要有内容 一开始想到的是这部分内容做成cell或者sectionHeader改成sectionFooter (后来想来这些都麻烦了 直接header + sectionHeader完事 只不过要调整header的内容和frame sectionHeader可不动 scrollDidScrol:也单纯只做导航渐变的交互 无需监听改变布局)
/// 2. 暂停播放或者停止播放时,视频播放器需要跟随滚动sectionHeader悬停在屏幕顶部
/// 3. 对于这种一开始觉得手生,有难度,其实不然,真正做起来的时候,画了画草图,分析了一下层级和交互就开干了
///
/// 最简单的还是利用系统的东西去实现,自己监听改变悬停位置或者布局总觉着容易出问题~ 能解决问题才是关键  黑猫白猫🐱能抓到老鼠🐀 就是好猫🐈
///

#define kHeaderHeight 300

@interface WGBHoverViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL isHover;//是否悬停

@end

@implementation WGBHoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHover = YES;//默认悬停
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *hoverSwitch = [[UISwitch alloc] init];
    [hoverSwitch addTarget:self action:@selector(changeHoverState:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hoverSwitch];
    hoverSwitch.on = self.isHover;
    [self.tableView reloadData];
}

- (void)changeHoverState:(UISwitch *)sw{
    self.isHover = sw.on;
    [MBProgressHUD showText:sw.on?  @"已开启悬停" : @"已关闭悬停" afterDelay:1];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = self.isHover? [UIView new] : self.headerView;
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
    return self.isHover? kHeaderHeight : 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.isHover? self.headerView : [UIView new];
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

@end
