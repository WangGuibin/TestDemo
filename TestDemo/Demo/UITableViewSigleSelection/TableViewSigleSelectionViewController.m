//
// TableViewSigleSelectionViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/8
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
    

#import "TableViewSigleSelectionViewController.h"
#import "TestSigleSelectTableViewCell.h"

@interface TableViewSigleSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *modelArray;
@property (nonatomic,strong) TestSigleSelectModel *selectModel;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TableViewSigleSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [TestSigleSelectModel craeteLocalDataWithCallBack:^(NSArray<TestSigleSelectModel *> * _Nonnull modelArray) {
        self.modelArray = modelArray;
        self.selectModel = modelArray.lastObject; //默认选中最后一个
        [self.tableView reloadData];
    }];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestSigleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TestSigleSelectTableViewCell class])];
    TestSigleSelectModel *model = self.modelArray[indexPath.row];
    cell.model = model;
    //显示已选中的项
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow: [self.modelArray indexOfObject: self.selectModel] inSection:0];
    [tableView selectRowAtIndexPath:selectIndexPath animated:YES  scrollPosition:(UITableViewScrollPositionNone)];
    self.textView.text = [NSString stringWithFormat:@"%@ - %@ - %@",self.selectModel.name,self.selectModel.sex,self.selectModel.age];

    return cell;
}

#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TestSigleSelectModel *model = self.modelArray[indexPath.row];
    self.selectModel = model;
    self.textView.text = [NSString stringWithFormat:@"%@ - %@ - %@",self.selectModel.name,self.selectModel.sex,self.selectModel.age];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.textView;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestSigleSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TestSigleSelectTableViewCell class])];
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



- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH , 100)];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor redColor];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.font = [UIFont boldSystemFontOfSize:30];
    }
    return _textView;
}

@end
