//
//  WGBEasyMarqueeViewDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBEasyMarqueeViewDemoViewController.h"
#import "WGBDemoViewController.h"
#import "HPAutoScorllTextLabel.h"

@interface WGBEasyMarqueeViewDemoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic)  UITableView *tableView;

@property (nonatomic,strong) NSArray<NSString*> *titles;

@end

@implementation WGBEasyMarqueeViewDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat screenW = UIScreen.mainScreen.bounds.size.width;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 35)];
    footer.backgroundColor = [UIColor cyanColor];

    HPAutoScorllTextLabel *label = [[HPAutoScorllTextLabel alloc] initWithFrame:CGRectMake(15, 0, screenW - 30, 35)];
    [footer addSubview: label];
    label.style = HPTextCycleStyleAlways;
    label.textColor = [UIColor orangeColor];
    label.text = @"`HPAutoScorllTextLabel`这个组件感觉不够优雅(需要手动管理定时器的生命周期)，所以才决定重写了`JXMarqueeView`的OC版";
    label.font = [UIFont systemFontOfSize:18];
    [label start];
    
    self.tableView.tableFooterView = footer;
    [self.tableView reloadData];
}


- (NSArray<NSString *> *)titles{
    return @[
             @"WGBEasyMarqueeTypeLeft",
             @"WGBEasyMarqueeTypeRight",
             @"WGBEasyMarqueeTypeReverse",
             @"自定义View",
             ];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WGBDemoViewController *demoVC = [[WGBDemoViewController alloc] init];
    demoVC.marqueeType = indexPath.row;
    demoVC.title = self.titles[indexPath.row];
    [self.navigationController presentViewController:demoVC animated:YES completion:^{
        
    }];
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(88, 0, 0, 0));
        }];
    }
    return _tableView;
}

@end
