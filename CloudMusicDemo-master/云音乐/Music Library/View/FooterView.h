//
//  FooterView.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
#import "LrcLabel.h"
@interface FooterView : UIView

@property (nonatomic,strong) UIImageView *singerImageV;//歌手图片
@property (nonatomic,strong) UILabel *songName;//歌名
@property (nonatomic,strong) LrcLabel *lrc;//歌词
@property (nonatomic,strong) UIButton *playBtn;//播放按钮
@property (nonatomic,strong) UIButton *TransparentBtn;//透明按钮
@property (nonatomic,strong) MusicModel *model;//音乐模型
+ (instancetype)initWithFooterViewFrame:(CGRect)frame;

- (void)setModel:(MusicModel *)model;
@end
