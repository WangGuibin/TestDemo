//
//  PlayFooterView.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressBar.h"
@interface PlayFooterView : UIView

@property(nonatomic,strong) UILabel *currentTime;//当前播放时间
@property(nonatomic,strong) UILabel *totalTime;//总时间
@property(nonatomic,strong) ProgressBar *progressBar;//进度条
@property(nonatomic,strong) UIButton *previousBtn;//上一曲
@property(nonatomic,strong) UIButton *playBtn;//播放／暂停
@property(nonatomic,strong) UIButton *nextBtn;//下一曲

+ (instancetype)initWithPlayFooterView:(CGRect)frame;
@end
