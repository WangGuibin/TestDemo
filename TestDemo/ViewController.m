//
//  ViewController.m
//  TestDemo
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+TouchHints.h"
#import "AnimationDemoViewController.h"
#import "TableViewDemoViewController.h"
#import "DebugDemoViewController.h"
#import "AlertDemoViewController.h"
#import "LayoutDemoListViewController.h"
#import "WGBCustomComponentDemoViewController.h"
#import "JXCategoryDemoViewController.h"
#import "WGBSpecialEffectDemoViewController.h"
#import "WGBIGListKitDemoViewController.h"
#import "DesignPatternsDemoListViewController.h"
#import "WGBOptimizationDemoListViewController.h"
#import "WGBVideoDemoListViewController.h"
#import "HMDebugToolView.h"
#import "UIView+DragExtension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak)  UIRefreshControl *refreshControl ;

@property (nonatomic,strong) NSArray *demoTitleArray;
@property (nonatomic,strong) NSArray<Class> *demoClassArray;


@end

@implementation ViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [AnimationDemoViewController class],
        [TableViewDemoViewController class],
        [DebugDemoViewController class],
        [AlertDemoViewController class],
        [LayoutDemoListViewController class],
        [WGBCustomComponentDemoViewController class],
        [JXCategoryDemoViewController class],
        [WGBSpecialEffectDemoViewController class],
        [WGBIGListKitDemoViewController class],
        [DesignPatternsDemoListViewController class],
        [WGBOptimizationDemoListViewController class],
        [WGBVideoDemoListViewController class]
    ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"动画相关demo",
        @"TableView相关demo",
        @"Debug相关demo",
        @"弹窗相关demo",
        @"布局相关demo",
        @"自定义组件或者工具",
        @"JXCategoryView的一些demo实践",
        @"特殊效果demo",
        @"IGListKit demo",
        @"设计模式相关",
        @"性能调优相关",
        @"音视频相关demo",
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
    
    //录屏的时候的一个手势图标展示
//    [[UIApplication sharedApplication] tch_enableTouchHintsWithImage: [UIImage imageNamed:@"touch"]];
    if (@available(iOS 13.0, *)) {
        HMDebugToolView *debugView = [[HMDebugToolView alloc] initWithFrame:CGRectMake(KWIDTH-60, 500, 55, 20)];
        debugView.wgb_canDrag = YES;
        UIView *rootView = self.view;
        [rootView addSubview:debugView];
        [rootView bringSubviewToFront:debugView];
    }
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
    [self testCrash:@[]];
    [self testCrash:@[@"1",@"2",@"666~ 没有crash"]];
    
    Class cls = self.demoClassArray[indexPath.row];
    UIViewController *vc = (UIViewController *)[[cls alloc] init];
    vc.navigationItem.title = self.demoTitleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
///测试Felix
- (void)testCrash:(id)args{
    if (args) {
        NSLog(@"%@",args[2]);
    }
}

@end
