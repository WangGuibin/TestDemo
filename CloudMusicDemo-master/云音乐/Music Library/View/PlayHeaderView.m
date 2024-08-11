//
//  PlayHeaderView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "PlayHeaderView.h"

@implementation PlayHeaderView

+(instancetype)initWithPlayHeaderView:(CGRect)frame{
    PlayHeaderView *_playHeaderView = [[PlayHeaderView alloc]initWithFrame:frame];
    //_playHeaderView.backgroundColor = [UIColor redColor];
    
    //返回按钮
    _playHeaderView.returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playHeaderView addSubview:_playHeaderView.returnBtn];
    [_playHeaderView.returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    //_playHeaderView.returnBtn.backgroundColor = [UIColor redColor];
    //歌曲名
    _playHeaderView.title = [[UILabel alloc]init];
    [_playHeaderView addSubview:_playHeaderView.title];
    [_playHeaderView.title setTextAlignment:NSTextAlignmentCenter];
    [_playHeaderView.title setFont:[UIFont systemFontOfSize:20]];
    [_playHeaderView.title setTextColor:[UIColor whiteColor]];
    //歌手
    _playHeaderView.author = [[UILabel alloc]init];
    [_playHeaderView addSubview:_playHeaderView.author];
    [_playHeaderView.author setTextAlignment:NSTextAlignmentCenter];
    [_playHeaderView.author setTextColor:[UIColor whiteColor]];
    //设置约束
    [_playHeaderView.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playHeaderView).offset(10);
        make.left.equalTo(_playHeaderView).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [_playHeaderView.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playHeaderView).offset(10);
        make.left.equalTo(_playHeaderView.returnBtn.mas_right).offset(5);
        make.centerX.equalTo(_playHeaderView);
        make.height.equalTo(@40);
    }];
    
    [_playHeaderView.author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playHeaderView.title.mas_bottom).offset(10);
        make.bottom.equalTo(_playHeaderView).offset(-10);
        make.width.equalTo(@100);
        make.centerX.equalTo(_playHeaderView);
    }];
    return _playHeaderView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
