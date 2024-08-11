//
//  PlayMusicView.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/25.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayHeaderView.h"
#import "PlayFooterView.h"
#import "MusicModel.h"
#import "LrcLabel.h"
@interface PlayMusicView : UIView

@property(nonatomic,strong)PlayHeaderView *playHeaderView;//头视图
@property(nonatomic,strong)PlayFooterView *playFooterView;//尾视图
@property(nonatomic,strong)UIImageView *singerImageV;//歌手图片
@property(nonatomic,strong)LrcLabel *lrcLbl;//歌词
@property(nonatomic,strong)UIImageView *backgroundImgV;//背景图片
@property(nonatomic,strong)MusicModel *model;//音乐模型
@property(nonatomic,strong)UIScrollView *playScrollView;//滚动视图
@property(nonatomic,strong)UITableView *playTableView;//表视图
+ (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>)delegate;
@end
