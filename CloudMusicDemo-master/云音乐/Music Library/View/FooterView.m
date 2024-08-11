//
//  FooterView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "FooterView.h"
FooterView *_footerView;
@implementation FooterView

+(instancetype)initWithFooterViewFrame:(CGRect)frame{
    _footerView = [[FooterView alloc]initWithFrame:frame];
    _footerView.backgroundColor = LCZColor(247, 247, 247, 1);
    //1.创建歌手图片
    _footerView.singerImageV = [[UIImageView alloc]init];
    [_footerView addSubview:_footerView.singerImageV];
   // _footerView.singerImageV.backgroundColor = [UIColor redColor];
    //设置为圆形
    _footerView.singerImageV.layer.cornerRadius = 25;
    _footerView.singerImageV.layer.masksToBounds = YES;
    //添加约束
    [_footerView.singerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView).offset(5);
        make.left.equalTo(_footerView).offset(5);
        make.bottom.equalTo(_footerView).offset(-5);
        make.width.equalTo(@50);
    }];
    
    //2.创建歌名
    _footerView.songName = [[UILabel alloc]init];
    [_footerView addSubview:_footerView.songName];
    //
   // _footerView.songName.text = @"远走高飞";
    //添加约束
    [_footerView.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView).offset(10);
        make.left.equalTo(_footerView.singerImageV.mas_right).offset(5);
        make.height.equalTo(@20);
    }];
    //3.创建歌词
    _footerView.lrc = [[LrcLabel alloc]init];
    [_footerView addSubview:_footerView.lrc];
    //_footerView.lrc.text = @"远走高飞 - 金志文";
    [_footerView.lrc setTextColor:LCZColor(149, 149, 149, 1)];
    //添加约束
    [_footerView.lrc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.songName.mas_bottom).offset(5);
        make.left.equalTo(_footerView.singerImageV.mas_right).offset(5);
        make.right.equalTo(_footerView).offset(-70);
        make.height.equalTo(@15);
    }];
    //4.创建播放按钮
    _footerView.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_footerView addSubview:_footerView.playBtn];
    //[_footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
    
    //添加约束
    [_footerView.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView).offset(10);
        make.bottom.equalTo(_footerView).offset(-10);
        make.right.equalTo(_footerView).offset(-20);
        make.width.equalTo(@50);
    }];
    //5.创建透明按钮
    _footerView.TransparentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_footerView addSubview:_footerView.TransparentBtn];
    //添加约束
    [_footerView.TransparentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView);
        make.left.equalTo(_footerView);
        make.right.equalTo(_footerView.playBtn.mas_left).offset(-10);
        make.bottom.equalTo(_footerView);
    }];
    return _footerView;
}

//更新UI
- (void)setModel:(MusicModel *)model{
    [_footerView.singerImageV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    //歌曲名
    [_footerView.songName setText:model.song_name];
    //
    [_footerView.lrc setText:model.author_name];
    //改变播放按钮
    [_footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pause_normal"] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
