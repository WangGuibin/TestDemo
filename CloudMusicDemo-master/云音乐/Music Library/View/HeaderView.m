//
//  HeaderView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/20.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "HeaderView.h"
HeaderView *_headerView;
@implementation HeaderView

+ (instancetype)initWithViewFrame:(CGRect)frame{
    _headerView = [[HeaderView alloc]initWithFrame:frame];
    _headerView.backgroundColor = LCZColor(48, 195, 124,1);
    //音乐馆按钮
    _headerView.MLLbl = [[UILabel alloc]init];
    [_headerView.MLLbl setFont:[UIFont systemFontOfSize:18]];
    [_headerView.MLLbl setTextColor:[UIColor whiteColor]];
    _headerView.MLLbl.text = @"音乐库";
    [_headerView addSubview:_headerView.MLLbl];
    //添加约束
    [_headerView.MLLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(25);
        make.centerX.equalTo(_headerView);
    }];
    //搜索框
    _headerView.SearchB = [[UISearchBar alloc]init];
    _headerView.SearchB.placeholder = @"搜索";
    
    [_headerView addSubview:_headerView.SearchB];
    //添加约束
    [_headerView.SearchB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.MLLbl.mas_bottom).offset(5);
        make.right.equalTo(_headerView).offset(-5);
        make.left.equalTo(_headerView).offset(5);
        make.height.equalTo(@40);
    }];
    //隐藏search边框
    [_headerView.SearchB setSearchBarStyle:UISearchBarStyleMinimal];
    return _headerView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
