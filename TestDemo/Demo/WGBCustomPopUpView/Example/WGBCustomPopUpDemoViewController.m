//
//  WGBCustomPopUpDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBCustomPopUpDemoViewController.h"
#import "WGBRewardAlertView.h"

@interface WGBCustomPopUpDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation WGBCustomPopUpDemoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    [self.tableView reloadData];
}

- (void)refresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
    });
}

- (NSArray *)titleArray{
    return @[
             @"自定义View示例之打赏",
             @"自定义View示例之引导充值",
             @"自定义View示例之提示消息",
             @"系统弹窗封装之Alert",
             @"系统弹窗封装之Alert Easy版",
             @"系统弹窗封装之AlertSheet",
             @"个性签名编辑&&字数限制&&监听键盘高度自适应",
             @"性别选择",
             @"基于StackView自定义弹窗一个按钮",
             @"基于StackView自定义弹窗两个按钮",
             @"发布动态选择资源弹窗"
             ];
}


#pragma mark -  UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self showRewardAlertView];
        }
            break;
        case 1:
        {
            [self showGudieVIP];
        }
            break;
        case 2:
        {
            [self showTips];
        }
            break;
        case 3:
        {
            [self showSystemAlert];
        }
            break;
        case 4:
        {
            [self showSystemEasyAlert];
        }
            break;
        case 5:
        {
            [self showSystemAlertSheet];
        }
            break;
        case 6:
        {
            [self editSignatureAction];
        }
            break;
        case 7:
        {
            [self chooseGenderAction];
        }
            break;
        case 8:
        {
            [self customAlertOneButtonStyle];
        }
            break;
        case 9:
        {
            [self customAlertTwoButtonStyle];
        }
            break;
        case 10:
        {
            [WGBAlertTool showPostSelectMediaAlertViewWithCallBack:^(NSInteger index) {
                
            }];
        }
            break;

            
        default:
            break;
    }
}


- (void)showRewardAlertView{
    WGBRewardAlertView *alerView = [[WGBRewardAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    //弹出通用类
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    pop.contentView = alerView;
    pop.animationType = WGBAlertAnimationTypeCenter;//WGBAlertAnimationTypeAlert
    alerView.balanceValue = 6.66;
    [alerView setCancelBlock:^{
        [pop dismiss];
    }];
    [alerView setConfirmBlock:^(BOOL canPay, NSString * _Nonnull money, NSString * _Nonnull message) {
        NSLog(@"能否支付：%@ \n 金额：%@ \n 留言：%@",canPay? @"能":@"不能",money,message);
        [pop dismiss];
    }];
    [pop showFromSuperView:self.view];
}

- (void)showGudieVIP{
    [WGBAlertTool showFreeTimesExpiredAlertWithCallBack:^(NSInteger index) {
        NSLog(@"下标: %ld",index);
    }];
}

- (void)showTips{
    [WGBAlertTool showCommitConfirmCheckReviewTips:@"我只是一条提示消息" callBack:^(NSInteger index) {
        NSLog(@"下标: %ld",index);
    }];
}

- (void)showSystemAlert{
    [WGBAlertTool showSystemStyleAlertSheetWithTitle:@"提示" alertMessage:@"消息消息消息消息消息消息消息消息" cancelTitle:@"取消" otherItemsTitle:@[@"确定"] preferredStyle:(UIAlertControllerStyleAlert) handler:^(NSInteger index) {
        NSLog(@"下标: %ld",index);
    }];
    
}

- (void)showSystemEasyAlert{
    [WGBAlertTool showSystemStyleCommonAlertTitle:@"温馨提示" messageTips:@"提示消息消息消息消息消息" leftButtonTitle:@"左按钮" rightButtonTitle:@"右按钮" leftButtonBlock:^{
        NSLog(@"左按钮回调");
    } rightButtonBlock:^{
        NSLog(@"右按钮回调");
    }];
}

- (void)showSystemAlertSheet{
    [WGBAlertTool showSystemStyleAlertSheetWithTitle:@"提示" alertMessage:@"消息消息消息消息消息消息消息消息" cancelTitle:@"取消" otherItemsTitle:@[@"确定",@"删除",@"置顶"] preferredStyle:(UIAlertControllerStyleActionSheet) handler:^(NSInteger index) {
        NSLog(@"下标: %ld",index);
    }];
    
}

- (void)editSignatureAction{
    [WGBAlertTool showSignatureInputAlertWithCallBack:^(NSString * _Nonnull signature) {
        NSLog(@"个性签名: %@",signature);
    }];
    
}

- (void)chooseGenderAction{
    [WGBAlertTool showSelectSexAlertViewWithCallBack:^(NSInteger sexIndex, NSString * _Nonnull selectSexValue) {
        NSLog(@"性别: %@ , 下标 %ld",selectSexValue,sexIndex);
    }];
}

- (void)customAlertOneButtonStyle{
    [WGBAlertTool showFeaturedLevelLimitAlertWithLeftBlock:^{
        
    } rightBlock:^{
        
    }];
}

- (void)customAlertTwoButtonStyle{
    [WGBAlertTool showCustomTipsAlertWithMessage:@"两个按钮的提示弹窗" fromSuperView:nil leftButtonTitle:@"left" rightButtonTitle:@"right" leftButtonBlock:^{
        
    } rightButtonBlock:^{
        
    }];
    
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
