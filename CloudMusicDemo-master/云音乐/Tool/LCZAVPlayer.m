//
//  LCZAVPlayer.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LCZAVPlayer.h"
#import "CALayer+Aimate.h"
#import "LrcModel.h"
#import "LRCTableViewCell.h"
LCZAVPlayer *_manager;
BOOL _singerAnimationStatus;
@implementation LCZAVPlayer

//单例
+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
    });
    
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:zone]init];
    });
    
    return _manager;
}

- (AVPlayer *)avPlayer{
    if (_avPlayer == nil) {
        _avPlayer = [[AVPlayer alloc]init];
    }
    return _avPlayer;
}

- (void)playMusicUrl:(NSURL *)url{
    self.mlViewController.playMusicView.lrcLbl.text = @"";
    //
    _singerAnimationStatus = NO;
    //播放状态
    self.stateOfPlay = YES;
    //当前索引
    self.currentIndex = 0;
    [self removeTime];
    [self removeLrcTime];
    //初始化播放单元
    self.avPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
    //切换歌曲
    [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
    //监测歌曲是否播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicFinsh:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self addTime];
    [self addLrcTime];
}

- (void)playMusic{
    [self.avPlayer play];
    [self addTime];
}

- (void)pauseMusic{
    [self.avPlayer pause];
    [self removeTime];
}

#pragma mark - 添加计时器
- (void)addTime{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    /*我们通常在主线程中使用NSTimer，有个实际遇到的问题需要注意。当滑动界面时，系统为了更好地处理UI事件和滚动显示，主线程runloop会暂时停止处理一些其它事件，这时主线程中运行的NSTimer就会被暂停。解决办法就是改变NSTimer运行的mode（mode可以看成事件类型），不使用缺省的NSDefaultRunLoopMode，而是改用NSRunLoopCommonModes，这样主线程就会继续处理NSTimer事件了*/
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//更新时间和进度条
- (void)updateTime{
    //获得当前播放时间
    CMTime t = [self.avPlayer currentTime];
    NSTimeInterval currentTimeSec = t.value / t.timescale;
    //获得总时间
    CMTime time = self.avPlayer.currentItem.duration;
    NSTimeInterval seconds = CMTimeGetSeconds(time);
    //开始播放时 播放歌手图片动画
    if (currentTimeSec / seconds >0 && _singerAnimationStatus == NO) {
        [self geShouImageAnimate:self.mlViewController.playMusicView.singerImageV];
        [self geShouImageAnimate:self.mlViewController.footerView.singerImageV];
        _singerAnimationStatus = YES;
    }
    //更新滚动条和时间
    self.mlViewController.playMusicView.playFooterView.progressBar.value = currentTimeSec / seconds;
    self.mlViewController.playMusicView.playFooterView.currentTime.text = [self convertTime:currentTimeSec];
    self.mlViewController.playMusicView.playFooterView.totalTime.text = [self convertTime:seconds];
}

#pragma - mark 删除计时器
- (void)removeTime{
    [self.timer invalidate];
    self.timer = nil;
}

//时间转换
- (NSString *)convertTime:(NSInteger)second{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [fmt setDateFormat:@"HH:mm:ss"];
    } else {
        [fmt setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [fmt stringFromDate:d];
    return showtimeNew;
}

#pragma mark - 歌手图片动画
- (void)geShouImageAnimate:(UIImageView *)imageView{
    //创建显示动画
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //起始值
    basic.fromValue = @(0);
    //结束时的值
    basic.toValue = @(M_PI *2);
    //重复的次数
    basic.repeatCount = NSIntegerMax;
    //旋转一周所用的时间
    basic.duration = 35;
    [imageView.layer addAnimation:basic forKey:nil];
}

#pragma mark 对歌词计时器的处理
- (void)addLrcTime{
    self.lrcTime = [CADisplayLink displayLinkWithTarget:self selector:@selector(upDateLrc)];
    [self.lrcTime addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)upDateLrc{
    //获得当前播放时间
    CMTime t = [self.avPlayer currentTime];
    NSTimeInterval currentTimeSec = t.value / t.timescale;
    
     //判断显示那句歌词
     for (NSInteger i = 0; i<self.lrcModelAry.count; i++) {
         //取出当前歌词
         LrcModel *model = self.lrcModelAry[i];
         //取出下一句歌词
         NSInteger index = i + 1;
         LrcModel *model2 = nil;
         if (index < self.lrcModelAry.count) {
             model2 = self.lrcModelAry[index];
         }
         //用当前播放器时间，跟当前这句歌词的时间和下一句歌词的时间对比，如果大于当前歌词时间，并且小于下一句歌词时间，就显示当前歌词
         if (self.currentIndex !=i && currentTimeSec >= model.time && currentTimeSec < model2.time | model2.time == 100) {
             //当前索引
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
             //上一行索引
            // NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
             //记录当前刷新的某行
             self.currentIndex = i;
             //刷新tableview
             [self.mlViewController.playMusicView.playTableView reloadData];
             //将当前歌词滚动到中间
             [self.mlViewController.playMusicView.playTableView  scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
             //设置主界面歌词
             self.mlViewController.playMusicView.lrcLbl.text = model.text;
             self.mlViewController.footerView.lrc.text = model.text;
         }
         
         if (self.currentIndex == i)//当前这句歌词
         {
             //当前歌词总时间 ／ 当前歌词以播放的时间
             CGFloat value = (model2.time - model.time) / (currentTimeSec - model.time);
             //设置当前歌词的播放进度
             NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
             LRCTableViewCell *cell = [self.mlViewController.playMusicView.playTableView  cellForRowAtIndexPath:currentIndexPath];
             cell.lrcLbl.pross = value;
             self.mlViewController.playMusicView.lrcLbl.pross = value;
             self.mlViewController.footerView.lrc.pross = value;
         }
     }
    
}

- (void)removeLrcTime{
    [self.lrcTime invalidate];
    self.lrcTime = nil;
}

//歌曲播放完成调用的方法
- (void)musicFinsh:(NSNotification *)sender{
    //还原按钮图片
    [self.mlViewController.footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
    [self.mlViewController.playMusicView.playFooterView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
    //播放下一首音乐
    [self.mlViewController nextMusic];
}

@end
