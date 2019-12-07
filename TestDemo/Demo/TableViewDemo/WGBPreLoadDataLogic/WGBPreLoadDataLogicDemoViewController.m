//
// WGBPreLoadDataLogicDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/7
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
    

#import "WGBPreLoadDataLogicDemoViewController.h"

#define threshold 0.7f    //阅读70%
#define itemPerPage 10.0f //每页10条数据
#define kDataMaxCount 100
@interface WGBPreLoadDataLogicDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isLoadingData;
@property (nonatomic,assign) BOOL hasMoreData;

@end

@implementation WGBPreLoadDataLogicDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self requestData];
    self.hasMoreData = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstPageData)];
}

- (void)loadFirstPageData{
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    self.page = 1;
    [self requestData];
}

- (void)requestData{
    self.isLoadingData = YES;
    __block MBProgressHUD *HUD = [MBProgressHUD showMessage:@"loading" toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < itemPerPage; i++) {
            NSDate *date = [NSDate date];
            NSString *str = [NSString stringWithFormat:@"page:%ld %@ 数据项%ld",self.page,[date string],i];
            [self.dataSource addObject: str];
            [self.tableView reloadData];
            if (i == itemPerPage-1) {
                if (self.tableView.mj_header.isRefreshing) {
                    [self.tableView.mj_header endRefreshing];                    
                }
                self.isLoadingData = NO;
                [HUD hideAnimated:YES afterDelay:0.25];
            }
            if (self.dataSource.count == 100) {
                self.hasMoreData = NO;
            }
        }
    });
}

#pragma mark UIScrollViewDelegate
/*
 控制器代码规范:
  https://casatwy.com/iosying-yong-jia-gou-tan-viewceng-de-zu-zhi-he-diao-yong-fang-an.html

 使用 Threshold 进行预加载是一种最为常见的预加载方式，知乎客户端就使用了这种方式预加载条目，而其原理也非常简单，根据当前 UITableView 的所在位置，除以目前整个 UITableView.contentView 的高度，来判断当前是否需要发起网络请求：
 */
/*
 下面的代码在当前页面已经划过了 70% 的时候，就请求新的资源，加载数据；但是，仅仅使用这种方法会有另一个问题，尤其是当列表变得很长时，十分明显，比如说：用户从上向下滑动，总共加载了 5 页数据：
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //当前所在位置
    CGFloat current = contentOffsetY + self.view.frame.size.height;
    //整个 UITableView.contentView 的高度
    CGFloat contentHeight = scrollView.contentSize.height;
    
//    NSLog(@"contentOffsetY: %.2f, self.view.frame.size.height: %.2f, contentSize.height: %.2f, ", scrollView.contentOffset.y, self.view.frame.size.height, scrollView.contentSize.height);

    if (isIphoneX()) {
        // iPhone X 减去底部安全区域 34.0f
        current -= 34.0f;
    }
    float ratio = current / contentHeight;
    
//https://zhuanlan.zhihu.com/p/23418800
    float needRead = itemPerPage * threshold + itemPerPage * (self.page - 1);
    float totalItem = itemPerPage * self.page;
    float newThreshold = needRead / totalItem;
//    NSLog(@"needRead: %.2f, totalItem: %.2f", needRead, totalItem);
    NSLog(@"ratio: %.2f, newThreshold: %.2f", ratio, newThreshold);

    if (ratio >= newThreshold && contentHeight > 0) {
        // 触发上拉加载更多
        if (self.isLoadingData || !self.hasMoreData) {
            return;
        }
        self.page += 1;
        //加载数据
        [self requestData];
    }
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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



- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
