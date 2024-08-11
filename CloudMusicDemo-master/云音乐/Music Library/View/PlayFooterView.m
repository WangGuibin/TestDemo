//
//  PlayFooterView.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "PlayFooterView.h"

@implementation PlayFooterView

+ (instancetype)initWithPlayFooterView:(CGRect)frame{
    PlayFooterView *_playFooterView = [[PlayFooterView alloc]initWithFrame:frame];
    //_playFooterView.backgroundColor = [UIColor redColor];
    //当前播放时间
    _playFooterView.currentTime = [[UILabel alloc]init];
    [_playFooterView addSubview:_playFooterView.currentTime];
    [_playFooterView.currentTime setTextColor:[UIColor whiteColor]];
    [_playFooterView.currentTime setFont:[UIFont systemFontOfSize:12]];
    _playFooterView.currentTime.text = @"00:00";
    //进度条
    _playFooterView.progressBar = [[ProgressBar alloc]init];
    [_playFooterView addSubview:_playFooterView.progressBar];
    [_playFooterView.progressBar setThumbImage:[UIImage imageNamed:@"sc_video_play_progress_current_position_icon"] forState:UIControlStateNormal];
    [_playFooterView.progressBar setTintColor:[UIColor greenColor]];
    _playFooterView.progressBar.value = 0;
    _playFooterView.progressBar.maximumValue = 1;
    _playFooterView.progressBar.minimumValue = 0;
    
    //总时间
    _playFooterView.totalTime = [[UILabel alloc]init];
    [_playFooterView addSubview:_playFooterView.totalTime];
    [_playFooterView.totalTime setTextColor:[UIColor whiteColor]];
    [_playFooterView.totalTime setFont:[UIFont systemFontOfSize:12]];
    _playFooterView.totalTime.text = @"00:00";
    //上一曲
    _playFooterView.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playFooterView addSubview:_playFooterView.previousBtn];
    _playFooterView.previousBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playFooterView.previousBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pre_normal"] forState:UIControlStateNormal];
    //播放／暂停按钮
    _playFooterView.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playFooterView addSubview:_playFooterView.playBtn];
    _playFooterView.playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playFooterView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
    //下一曲按钮
    _playFooterView.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playFooterView addSubview:_playFooterView.nextBtn];
    _playFooterView.nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playFooterView.nextBtn setImage:[UIImage imageNamed:@"landscape_player_btn_next_normal"] forState:UIControlStateNormal];
    //添加约束
    [_playFooterView.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView).offset(10);
        make.left.equalTo(_playFooterView).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_playFooterView.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView).offset(10);
        make.right.equalTo(_playFooterView).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_playFooterView.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView).offset(5);
        make.left.equalTo(_playFooterView.currentTime.mas_right).offset(10);
        make.right.equalTo(_playFooterView.totalTime.mas_left).offset(-10);
        
    }];
    
    [_playFooterView.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView.currentTime.mas_bottom).offset(20);
        make.left.equalTo(_playFooterView).offset(30);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    [_playFooterView.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView.totalTime.mas_bottom).offset(20);
        make.right.equalTo(_playFooterView).offset(-30);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    [_playFooterView.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playFooterView.totalTime.mas_bottom).offset(10);
        make.centerX.equalTo(_playFooterView);
        make.height.equalTo(@100);
        make.width.equalTo(@100);
    }];
    return _playFooterView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
