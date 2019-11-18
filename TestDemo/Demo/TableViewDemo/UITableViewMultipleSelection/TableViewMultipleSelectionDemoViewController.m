//
//  TableViewMultipleSelectionDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/11/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TableViewMultipleSelectionDemoViewController.h"
#import "TestDeleteButtonTableViewCell.h"
#import "HPCannonBottomOperationView.h"
#import "HPCannonBottomOperationView.h"

@interface TableViewMultipleSelectionDemoViewController ()<UITableViewDelegate, UITableViewDataSource,HPCannonBottomOperationViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectDataSource;

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) HPCannonBottomOperationView *operationView;

@end

@implementation TableViewMultipleSelectionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];

    
    for (NSInteger i = 1; i < 50; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:indexPath];
    }
    [self.tableView reloadData];
}


///MARK:- 编辑
- (void)editButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.view bringSubviewToFront: self.operationView];
    [self refreshAllSelectButtonState];
    if (sender.isSelected) {
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        [self.tableView setEditing:YES animated:NO];
        [self showOperationView];
    }else{
        [self.tableView setEditing:NO animated:NO];
        [self hiddenOperationView];
    }
}

///MARK:- 展示操作视图
- (void)showOperationView{
    [UIView animateWithDuration:0.25 animations:^{
        self.operationView.frame = CGRectMake(0, KHIGHT - 50 - (kBottomHeight), KWIDTH , 50);
    } completion:^(BOOL finished) {
        if (self.selectDataSource.count) {
            [self.selectDataSource removeAllObjects];
        }
    }];
}

///MARK:- 隐藏操作视图
- (void)hiddenOperationView{
    [UIView animateWithDuration:0.25 animations:^{
        self.operationView.frame = CGRectMake(0, KHIGHT, KWIDTH , 50);
    } completion:^(BOOL finished) {
        if (self.selectDataSource.count) {
            [self.selectDataSource removeAllObjects];
        }
    }];
}

///MARK:- 刷新全选按钮状态
- (void)refreshAllSelectButtonState{
    self.operationView.allSelectButton.selected = NO;
    if (!self.dataSource.count) {
        return;
    }
    if (!self.selectDataSource.count) {
        return;
    }
    
    if (self.dataSource.count == self.selectDataSource.count) {
        self.operationView.allSelectButton.selected = YES;
    }
}

///MARK:- <HPCannonBottomOperationViewDelegate>
- (void)allSelectAction:(BOOL)isSelectAll{
    // 全选
    NSInteger count = self.dataSource.count;
    if (isSelectAll) {
        for (NSInteger i = 0 ; i < count; i++){
            NSIndexPath *indexPath = self.dataSource[i];
            if (![self.selectDataSource containsObject:indexPath]) {
                [self.selectDataSource addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self refreshAllSelectButtonState];
        }
    }else{
        for (NSInteger i = 0 ; i < count; i++){
            NSIndexPath *indexPath = self.dataSource[i];
            if ([self.selectDataSource containsObject:indexPath]) {
                [self.selectDataSource removeObject:indexPath];
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
            [self refreshAllSelectButtonState];
        }
    }
}

- (void)deletePostListAction{
    if (!self.selectDataSource.count) {
        return;
    }
    // 删除数据源
    [self.dataSource removeObjectsInArray:self.selectDataSource];
    [self.selectDataSource removeAllObjects];
    
    // 删除选中项
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self refreshAllSelectButtonState];
    if (!self.dataSource.count) {
        //没有数据liao
        self.editButton.selected = NO;
        [self hiddenOperationView];
        [self.tableView reloadData];
    }
}


#pragma mark - tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestDeleteButtonTableViewCell class])];
    
    return cell;
}


#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:nil handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableArray *tempArr = self.dataSource;
        [tempArr removeObjectAtIndex:indexPath.row];
        self.dataSource = tempArr ;
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        NSLog(@"删除回调");
    }];
    action.backgroundColor = RGBA(0, 0, 0, 0);
    return @[action];
}

// 选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *indexPathObj = self.dataSource[indexPath.row];
    if (tableView.isEditing) {
        if (![self.selectDataSource containsObject:indexPathObj]) {
            [self.selectDataSource addObject:indexPathObj];
        }
        [self refreshAllSelectButtonState];
        return;
    }
}

// 取消选中
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing){
        NSIndexPath *indexPathObj = self.dataSource[indexPath.row];
        if ([self.selectDataSource containsObject:indexPathObj]) {
            [self.selectDataSource removeObject:indexPathObj];
        }
        [self refreshAllSelectButtonState];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete ;
    }
    return UITableViewCellEditingStyleNone;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelection = YES;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestDeleteButtonTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TestDeleteButtonTableViewCell class])];
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


- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(0, 0, 60 , 25);
        [_editButton setTitleColor:RGB(0,0,0) forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"取消" forState:UIControlStateSelected];
         [_editButton addTarget:self action:@selector(editButtonAction:)  forControlEvents:UIControlEventTouchUpInside];
     }
    return _editButton;
}

- (HPCannonBottomOperationView *)operationView {
    if (!_operationView) {
        _operationView = [HPCannonBottomOperationView fromXIB];
        _operationView.frame = CGRectMake(0, KHIGHT, KWIDTH , 50);
        _operationView.delegate = self;
        [self.view addSubview: _operationView];
    }
    return _operationView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (NSMutableArray *)selectDataSource {
    if (!_selectDataSource) {
        _selectDataSource = [[NSMutableArray alloc] init];
    }
    return _selectDataSource;
}

@end
