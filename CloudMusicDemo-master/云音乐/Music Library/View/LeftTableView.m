//
//  LeftTableView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LeftTableView.h"
#import "LeftTableViewCell.h"
@implementation LeftTableView

+ (instancetype)initWithLeftTableViewFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate{
    LeftTableView *_leftTableView = [[LeftTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    //delegate
    _leftTableView.delegate = delegate;
    _leftTableView.dataSource = delegate;
    [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:@"leftCell"];
    //删除分割线
    [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _leftTableView.backgroundColor = LCZColor(244, 244, 244,1);
    return _leftTableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
