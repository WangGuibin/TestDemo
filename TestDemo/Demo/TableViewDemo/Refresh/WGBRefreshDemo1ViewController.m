//
// WGBRefreshDemo1ViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/9/2
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
    

#import "WGBRefreshDemo1ViewController.h"
#import "WGBDemoRefreshHeder.h"

@interface WGBRefreshDemo1ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WGBDemoRefreshHeder *refreshHeader;
@property (nonatomic, strong) WGBDemoRefreshHeder *refreshFooter;

@end

@implementation WGBRefreshDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    self.refreshHeader.frame = CGRectMake(0, -100, KWIDTH , 100);
    self.refreshFooter.frame = CGRectMake(0, self.tableView.contentSize.height, KWIDTH , 100);

    [self.refreshHeader stopAnimation];

}

//滚动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        if (offsetY > scrollView.contentSize.height - scrollView.height + 50) {
            [self.refreshFooter startAnimation];
            self.refreshFooter.tipsLabel.text = @"正在加载...";
        }else{
            [self.refreshFooter stopAnimation];
            self.refreshFooter.tipsLabel.text = @"上拉加载更多";
        }
        return;
    }
    if (offsetY < -80) {
        [self.refreshHeader startAnimation];
    }else{
        [self.refreshHeader stopAnimation];
    }
}

//松手了
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        if (offsetY > scrollView.contentSize.height - scrollView.height + 50) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
            [self.refreshFooter startAnimation];
            self.refreshFooter.tipsLabel.text = @"正在加载...";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView.contentInset = UIEdgeInsetsZero;
                    [self.refreshFooter stopAnimation];
                    self.refreshFooter.tipsLabel.text = @"上拉加载更多";
                }];
            });
        }
        return;
    }
    if (offsetY < -50) {
        [UIView animateWithDuration:0.25 animations:^{
            [self refreshingUI];
        }];
    }
    
}


- (void)refreshingUI{
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [self.refreshHeader startAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            [self normalUI];
        }];
    });
}

- (void)normalUI{
    self.tableView.contentInset = UIEdgeInsetsZero;
    [self.refreshHeader stopAnimation];
}


#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = @(indexPath.row + 10000000).stringValue;
//    cell.backgroundColor = [UIColor colorWithHue:(arc4random() % 256/256.0) saturation:((arc4random() % 128 / 256.0) + 0.5) brightness:((arc4random() % 128 / 256.0) + 0.5) alpha:1];
    cell.backgroundColor = indexPath.row %2 == 0? [UIColor whiteColor] : [UIColor groupTableViewBackgroundColor];
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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



- (WGBDemoRefreshHeder *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [[WGBDemoRefreshHeder alloc] initWithFrame:CGRectMake(0, -100, KWIDTH , 100)];
        [self.tableView addSubview:_refreshHeader];
    }
    return _refreshHeader;
}


- (WGBDemoRefreshHeder *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [[WGBDemoRefreshHeder alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 100)];
        [self.tableView addSubview:_refreshFooter];
    }
    return _refreshFooter;
}

@end
