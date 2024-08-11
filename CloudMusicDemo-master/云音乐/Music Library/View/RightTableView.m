//
//  RightTableView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "RightTableView.h"
#import "RightTableViewCell.h"
@implementation RightTableView


+ (instancetype)initWithRightTableViewFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate{
    RightTableView *_rightTableView = [[RightTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _rightTableView.delegate = delegate;
    _rightTableView.dataSource = delegate;
    [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:@"rightCell"];
    _rightTableView.rowHeight = 65;
    return _rightTableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
