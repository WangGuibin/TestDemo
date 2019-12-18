//
//  NormalUseViewController.m
//  RunLoopDemo
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NormalUseViewController.h"
#import "YYFPSLabel.h"

@interface NormalUseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation NormalUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"优化前";
    [self.tableView reloadData];
    [self fpsLabel];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    [self removeCellSubViewsWithCurrentCell: cell indexPath: indexPath];
    [self configCellUIWithCell: cell indexPath: indexPath];
    return cell;
}

//创建配置cell UI
- (void)configCellUIWithCell:(UITableViewCell *)cell
                   indexPath:(NSIndexPath *)indexPath{
    //文本
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor redColor];
    topLabel.text = [NSString stringWithFormat:@"%zd - 绘制cell上方下标Label 不损耗多少资源 优先级可以高一些", indexPath.row];
    topLabel.font = [UIFont boldSystemFontOfSize:13];
    topLabel.tag = 1;
    [cell.contentView addSubview:topLabel];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];

    //图1
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView1.tag = 2;
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.image = image;
    [UIView transitionWithView:cell.contentView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView1];
    } completion:^(BOOL finished) {
    }];
    
    //图2
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView2.tag = 3;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    imageView2.image = image;
    [UIView transitionWithView:cell.contentView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imageView2];
    } completion:^(BOOL finished) {
    }];

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
    bottomLabel.numberOfLines = 0;
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    bottomLabel.text = [NSString stringWithFormat:@"%zd - 绘制大图的优先级较低。 应该优先分配给不同的运行循环去做这件事.", indexPath.row];
    bottomLabel.font = [UIFont boldSystemFontOfSize:13];
    bottomLabel.tag = 4;
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView3.tag = 5;
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    imageView3.image = image;
    [UIView transitionWithView:cell.contentView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:bottomLabel];
        [cell.contentView addSubview:imageView3];
    } completion:^(BOOL finished) {
    }];
}

//移除当前cell的子view
- (void)removeCellSubViewsWithCurrentCell:(UITableViewCell *)cell
                                indexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 1; i <= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width , self.view.bounds.size.height - 100) style:UITableViewStylePlain];
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (YYFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 100, 80 , 21)];
        [self.view addSubview:_fpsLabel];
    }
    return _fpsLabel;
}

@end
