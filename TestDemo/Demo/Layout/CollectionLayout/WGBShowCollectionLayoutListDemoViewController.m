//
// WGBShowCollectionLayoutListDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/23
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
    

#import "WGBShowCollectionLayoutListDemoViewController.h"
#import "WGBCollectionLayoutDemoViewController.h"
#import "WGBCollectionItemCenterFlowLayout.h"
#import "WGBZoomScaleFlowLayout.h"
#import "MaximumSpacingFlowLayout.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface WGBShowCollectionLayoutListDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;

@end

@implementation WGBShowCollectionLayoutListDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];

}

#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSArray *)titles{
    return @[
        @"居中布局",
        @"普通布局",
        @"两边小中间变大布局",
        @"居左自适应布局",
        @"左对齐布局"
    ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titles[indexPath.row];
    
    if ([title isEqualToString:@"居中布局"]) {
        WGBCollectionItemCenterFlowLayout *layout = [WGBCollectionItemCenterFlowLayout new];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        WGBCollectionLayoutDemoViewController *layoutVC = [WGBCollectionLayoutDemoViewController new];
        layoutVC.layout = layout;
        layoutVC.navigationItem.title = title;
        [self.navigationController pushViewController:layoutVC animated:YES];
    }else if ([title isEqualToString:@"普通布局"]) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        WGBCollectionLayoutDemoViewController *layoutVC = [WGBCollectionLayoutDemoViewController new];
        layoutVC.layout = layout;
        layoutVC.navigationItem.title = title;
        [self.navigationController pushViewController:layoutVC animated:YES];
    }else if ([title isEqualToString:@"两边小中间变大布局"]) {
        WGBZoomScaleFlowLayout *layout = [WGBZoomScaleFlowLayout new];
        layout.itemSize = CGSizeMake(300, 400);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        WGBCollectionLayoutDemoViewController *layoutVC = [WGBCollectionLayoutDemoViewController new];
        layoutVC.layout = layout;
        layoutVC.navigationItem.title = title;
        [self.navigationController pushViewController:layoutVC animated:YES];
    }else if([title isEqualToString:@"居左自适应布局"]){
        MaximumSpacingFlowLayout *layout = [MaximumSpacingFlowLayout new];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        WGBCollectionLayoutDemoViewController *layoutVC = [WGBCollectionLayoutDemoViewController new];
        layoutVC.layout = layout;
        layoutVC.navigationItem.title = title;
        [self.navigationController pushViewController:layoutVC animated:YES];
    }else if ([title isEqualToString:@"左对齐布局"]){
        UICollectionViewLeftAlignedLayout *layout = [UICollectionViewLeftAlignedLayout new];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        WGBCollectionLayoutDemoViewController *layoutVC = [WGBCollectionLayoutDemoViewController new];
        layoutVC.layout = layout;
        layoutVC.navigationItem.title = title;
        [self.navigationController pushViewController:layoutVC animated:YES];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        adjustsScrollViewInsets_NO(_tableView, self);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.mas_equalTo(kNavBarHeight);
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

@end
