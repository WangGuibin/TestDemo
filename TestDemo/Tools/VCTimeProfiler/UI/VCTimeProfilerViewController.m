//
//  VCTimeProfilerViewController.m
//  VCTimeProfiler
//
//  Created by SuXinDe on 2018/8/6.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "VCTimeProfilerViewController.h"
#import "VCTimeProfilerRecorder.h"

@interface CallTraceViewControllerViewModel ()

@property (nonatomic, copy) NSArray<VCTimeProfilerRecord *> *records;

@end

@implementation CallTraceViewControllerViewModel

- (instancetype)initWithViewControllerTimeRecords:(NSArray<VCTimeProfilerRecord *> *)records {
    if (self = [super init]) {
        self.records = [records copy];
    }
    return self;
}

- (NSInteger)numberOfSection {
    return 1;
}

- (NSInteger)numberOfCellForSection:(NSInteger)section {
    return self.records.count;
}

@end


@interface VCTimeProfilerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CallTraceViewControllerViewModel *viewModel;
@end

@implementation VCTimeProfilerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    self.tableView.estimatedRowHeight = 100; // 设置估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 告诉tableView Cell的高度是自动填充的
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.view = self.tableView;
    
    self.viewModel = [[CallTraceViewControllerViewModel alloc] initWithViewControllerTimeRecords:[[VCTimeProfilerRecorder shared] records]];
    
    [self updateTableView];
}

- (void)updateTableView {
    if ([self.viewModel numberOfSection] == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        UILabel *notDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, self.view.bounds.size.width, 64)];
        notDataLabel.textColor = [UIColor lightGrayColor];
        notDataLabel.font = [UIFont systemFontOfSize:14];
        notDataLabel.textAlignment = NSTextAlignmentCenter;
        notDataLabel.numberOfLines = 0.f;
        notDataLabel.text = [NSString stringWithFormat:@"未检测到相关记录"];
        [footerView addSubview:notDataLabel];
        self.tableView.tableFooterView = footerView;
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    
    [self.tableView reloadData];
}

// MARK: - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfCellForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    VCTimeProfilerRecord *model = self.viewModel.records[indexPath.row];
    cell.textLabel.text = model.description;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
