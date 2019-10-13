//
//  ViewController.m
//  TestDemo
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "WGBCustomPopUpDemoViewController.h"
#import "WGBEasyMarqueeViewDemoViewController.h"
#import "WGBWaveLayerButtonDemoViewController.h"
#import "WGBCommonAlertSheetViewDemoViewController.h"
#import "WGBRepairedOrientationLabelDemoViewController.h"
#import "NSLayoutAnchorDemoViewController.h"
#import "YYTextDemoViewController.h"
#import "FancyQRCodeToolDemoViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak)  UIRefreshControl *refreshControl ;

@property (nonatomic,strong) NSArray *demoTitleArray;
@property (nonatomic,strong) NSArray<Class> *demoClassArray;


@end

@implementation ViewController

- (NSArray<Class> *)demoClassArray{
    return @[
             [WGBCustomPopUpDemoViewController class],
             [WGBEasyMarqueeViewDemoViewController class],
             [WGBWaveLayerButtonDemoViewController class],
             [WGBCommonAlertSheetViewDemoViewController class],
             [WGBRepairedOrientationLabelDemoViewController class],
             [NSLayoutAnchorDemoViewController class],
             [YYTextDemoViewController class],
             [FancyQRCodeToolDemoViewController class]
             ];
}


- (NSArray *)demoTitleArray{
    return @[
             @"WGBCustomPopUpView",
             @"WGBEasyMarqueeView",
             @"WGBWaveLayerButton",
             @"WGBCommonAlertSheetView",
             @"WGBRepairedOrientationLabel",
             @"iOS 布局约束`NSLayoutAnchor`学习",
             @"YYTextDemoViewController测试学习",
             @"花式二维码"
             ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"平时积累的一些Demo";
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshTabView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview: refreshControl];
    self.refreshControl = refreshControl;
    [self.tableView reloadData];
    
}

- (void)refreshTabView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}


#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.demoTitleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text =  self.demoTitleArray[indexPath.row];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = self.demoClassArray[indexPath.row];
    UIViewController *vc = (UIViewController *)[[cls alloc] init];
    vc.navigationItem.title = self.demoTitleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
