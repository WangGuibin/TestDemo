//
//  LCZAVPlayer.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MLViewController.h"
//block是用来通知控制器切换歌曲使用的
typedef void(^NextMusicBlock)(void);

@interface LCZAVPlayer : NSObject
@property(nonatomic,strong) AVPlayer *avPlayer;
@property(nonatomic,strong) AVPlayerItem *avPlayerItem;
@property(nonatomic,copy) NextMusicBlock musicBlock;
@property(nonatomic,strong) MLViewController *mlViewController;
@property(nonatomic,strong) NSTimer *timer;//计时器。更新UI
@property(nonatomic,strong) CADisplayLink *lrcTime;//歌词计时器
@property(nonatomic,strong) NSMutableArray *lrcModelAry;//歌词模型数组
@property (nonatomic,assign)NSInteger currentIndex;//记得当前刷新的某行
@property(nonatomic,assign) BOOL stateOfPlay;
//管理
+(instancetype)manager;
//播放音乐，上一曲，下一曲
- (void)playMusicUrl:(NSURL *)url;
//暂停音乐
- (void)pauseMusic;
//播放音乐
- (void)playMusic;
//添加计时器
- (void)addTime;
//移除计时器
- (void)removeTime;
//时间转换
- (NSString *)convertTime:(NSInteger)second;
@end
