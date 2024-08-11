//
//  PlayMusicView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/25.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "PlayMusicView.h"
#import "LRCTableViewCell.h"
@implementation PlayMusicView

+ (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>)delegate{
    PlayMusicView *_playMusicView = [[PlayMusicView alloc]initWithFrame:frame];
    _playMusicView.backgroundColor = [UIColor whiteColor];
    //背景图片
    _playMusicView.backgroundImgV = [[UIImageView alloc]initWithFrame:frame];
    [_playMusicView addSubview:_playMusicView.backgroundImgV];
    _playMusicView.backgroundImgV.contentMode = UIViewContentModeScaleAspectFit;
    [_playMusicView.backgroundImgV sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"guangDIe"]];
    //添加毛玻璃
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:frame];
    toolBar.barStyle = UIBarStyleBlack;
    [_playMusicView.backgroundImgV addSubview:toolBar];
    //创建头部视图
    _playMusicView.playHeaderView = [PlayHeaderView initWithPlayHeaderView:CGRectMake(0, 20, _playMusicView.frame.size.width, 100)];
    [_playMusicView addSubview:_playMusicView.playHeaderView];
    [_playMusicView.playHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playMusicView.mas_top).offset(44);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    //创建尾部视图
    _playMusicView.playFooterView = [PlayFooterView initWithPlayFooterView:CGRectMake(0, _playMusicView.frame.size.height-150, _playMusicView.frame.size.width, 150)];
    [_playMusicView addSubview:_playMusicView.playFooterView];
    
    //1.歌手图片
    _playMusicView.singerImageV = [[UIImageView alloc]init];
    _playMusicView.singerImageV.contentMode = UIViewContentModeScaleAspectFit;
    [_playMusicView addSubview:_playMusicView.singerImageV];
    //添加约束
    [_playMusicView.singerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playMusicView.playHeaderView.mas_bottom).offset(20);
        make.left.equalTo(_playMusicView).offset(18);
        make.width.height.mas_equalTo(_playMusicView.frame.size.width-36);
    }];
    _playMusicView.singerImageV.layer.borderColor = LCZColor(36, 36, 36, 1).CGColor;
    _playMusicView.singerImageV.layer.borderWidth = 5;
    _playMusicView.singerImageV.layer.cornerRadius = (_playMusicView.frame.size.width-36) *0.5;
    _playMusicView.singerImageV.layer.masksToBounds = YES;
    
    //2.歌词
    _playMusicView.lrcLbl = [[LrcLabel alloc]init];
    [_playMusicView addSubview:_playMusicView.lrcLbl];
    [_playMusicView.lrcLbl setFont:[UIFont systemFontOfSize:25]];
    [_playMusicView.lrcLbl setTextAlignment:NSTextAlignmentCenter];
    [_playMusicView.lrcLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playMusicView.singerImageV.mas_bottom).offset(10);
        make.bottom.equalTo(_playMusicView.playFooterView.mas_top).offset(-5);
        make.left.equalTo(_playMusicView).offset(20);
        make.right.equalTo(_playMusicView).offset(-20);
    }];

    //滚动视图
    _playMusicView.playScrollView = [[UIScrollView alloc]init];
    _playMusicView.playScrollView.delegate = delegate;
    _playMusicView.playScrollView.contentSize = CGSizeMake(_playMusicView.frame.size.width*2, 0);
    _playMusicView.playScrollView.pagingEnabled = YES;
    [_playMusicView addSubview:_playMusicView.playScrollView];
    
    //添加约束
    [_playMusicView.playScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playMusicView.playHeaderView.mas_bottom).offset(0);
        make.bottom.equalTo(_playMusicView.playFooterView.mas_top).offset(0);
        make.width.equalTo(_playMusicView);
    }];
    
    //表视图
    _playMusicView.playTableView = [[UITableView alloc]initWithFrame:CGRectMake(_playMusicView.frame.size.width,0, _playMusicView.frame.size.width, frame.size.height-270)  style:UITableViewStylePlain];
    //设置内边距 不设置则tableview负偏移无效
    _playMusicView.playTableView.contentInset = UIEdgeInsetsMake(_playMusicView.playTableView.bounds.size.height * 0.5, 0, _playMusicView.playTableView.bounds.size.height * 0.5, 0);
    _playMusicView.playTableView.rowHeight = 40;
    [_playMusicView.playScrollView addSubview:_playMusicView.playTableView];
    _playMusicView.playTableView.delegate = delegate;
    _playMusicView.playTableView.dataSource = delegate;
    [_playMusicView.playTableView registerClass:[LRCTableViewCell class] forCellReuseIdentifier:@"lrcCell"];
    [_playMusicView.playTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _playMusicView.playTableView.backgroundColor = [UIColor clearColor];
   
    
    
    
    
    
    return _playMusicView;
}

- (void)setModel:(MusicModel *)model{
    self.playHeaderView.title.text = model.song_name;
    self.playHeaderView.author.text = model.author_name;
    [self.backgroundImgV sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [self.singerImageV sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [self.playFooterView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pause_normal"] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
