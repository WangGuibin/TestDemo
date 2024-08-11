//
//  MLViewController.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/20.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "MLViewController.h"
#import "LeftTableView.h"
#import "RightTableView.h"
#import "TableViewDelegate.h"
//#import "AFNTool.h"
#import "MusicModel.h"
#import "RankingListModel.h"
#import <AVFoundation/AVFoundation.h>
#import "CALayer+Aimate.h"
#import "LCZAVPlayer.h"
#import "SearchBarViewController.h"
@interface MLViewController ()<UISearchBarDelegate>
{
}

@property (nonatomic,strong) LeftTableView *leftTableView;//左tableView
@property (nonatomic,strong) RightTableView *rightTableView;//右tableView
@property (nonatomic,strong) NSMutableArray *rankModelAry;//排行榜音乐模型数组
@property(nonatomic,strong) LCZAVPlayer *manager;//音乐播放管理
@property (nonatomic,strong) TableViewDelegate *tableViewDelegate;//tableViewDalegate

@end

@implementation MLViewController

- (LCZAVPlayer *)manager{
    if (_manager == nil) {
        _manager = [LCZAVPlayer manager];
    }
    return _manager;
}

- (PlayMusicView *)playMusicView{
    if (_playMusicView == nil) {
        _playMusicView = [PlayMusicView initWithFrame:[UIScreen mainScreen].bounds andDelegate:self.tableViewDelegate];
    }
    return _playMusicView;
}

- (LCZMusicTool *)musicTool{
    if (_musicTool == nil) {
        _musicTool = [[LCZMusicTool alloc]init];
    }
    return _musicTool;
}


- (NSMutableArray *)rankModelAry{
    if (_rankModelAry == nil) {
        _rankModelAry = [NSMutableArray array];
    }
    return _rankModelAry;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.manager.stateOfPlay == YES) {
//        [self.footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pause_normal"] forState:UIControlStateNormal];
//    }
//    else{
//        [self.footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeaderView];
    [self createFooterView];
    [self createMain];
    [self createPlayMusicView];
    //加载第一次的数据
    [self loadTheData];
   
}
#pragma mark - 创建头部View
- (void)createHeaderView{
    self.headerView = [HeaderView initWithViewFrame:CGRectMake(0, 0, kWidth, 100)];
    [self.view addSubview:self.headerView];
    //设置搜索框代理
    self.headerView.SearchB.delegate = self;
}

#pragma mark - 内容部分
- (void)createMain{
    //实例化代理类
    self.tableViewDelegate = [[TableViewDelegate alloc]init];
    //实例化左tableView 并设置代理
    self.leftTableView = [LeftTableView initWithLeftTableViewFrame:CGRectMake(0, 100, kWidth *0.30, kHeight-160) andDelegate:self.tableViewDelegate];
    //传入leftTableView对象
    self.tableViewDelegate.leftTableView = self.leftTableView;
    
    
    //实例化右tableView 并设置代理
    self.rightTableView = [RightTableView initWithRightTableViewFrame:CGRectMake(kWidth*0.3, 100, kWidth*0.7, kHeight-160) andDelegate:self.tableViewDelegate];
    //传入rightTableView对象 和数据
    self.tableViewDelegate.rightTableView = self.rightTableView;
    self.tableViewDelegate.footerView = self.footerView;
    self.tableViewDelegate.mLViewController = self;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    }
#pragma mark - 创建尾部View
- (void)createFooterView{
    self.footerView = [FooterView initWithFooterViewFrame:CGRectMake(0, kHeight-60, kWidth, 60)];
    [self.view addSubview:self.footerView];
    //跳转播放界面
    [self.footerView.TransparentBtn addTarget:self action:@selector(jumpViewController) forControlEvents:UIControlEventTouchUpInside];
    //开始播放／暂停播放
    [self.footerView.playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 加载数据
- (void)loadTheData{

    [AFNTool GET:CoolDogSlipped parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        NSArray *jsonAry = [RankingListModel mj_objectArrayWithKeyValuesArray:dict[@"songs"][@"list"]];
        for (RankingListModel *rankModel in jsonAry) {
            [self.rankModelAry addObject:rankModel];
        }
        //传值给音乐工具类
        self.musicTool.musicModelAry = self.rankModelAry;
        //传值更新UI
        self.tableViewDelegate.rankModelAry = self.rankModelAry;
        [self.rightTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 音乐播放界面
- (void)createPlayMusicView{
    [self.view addSubview:self.playMusicView];
    //隐藏播放界面
    self.playMusicView.alpha = 0;
    //播放按钮
    [self.playMusicView.playFooterView.playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    //返回按钮
    [self.playMusicView.playHeaderView.returnBtn addTarget:self action:@selector(returnC) forControlEvents:UIControlEventTouchUpInside];
    //上一首音乐
    [self.playMusicView.playFooterView.previousBtn addTarget:self action:@selector(previousMusic) forControlEvents:UIControlEventTouchUpInside];
    //下一首音乐
    [self.playMusicView.playFooterView.nextBtn addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    //滚动条事件
    //按下
    [self.playMusicView.playFooterView.progressBar addTarget:self action:@selector(dianJi) forControlEvents:UIControlEventTouchDown];
    //单击结束
    [self.playMusicView.playFooterView.progressBar addTarget:self action:@selector(dianJiEnd) forControlEvents:UIControlEventTouchUpInside];
    //值改变事件
    [self.playMusicView.playFooterView.progressBar addTarget:self action:@selector(updateValue) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - 上一首音乐
- (void)previousMusic{
    [self removeAnimation];
    RankingListModel *model = [self.musicTool previousMusic];
    //self.musicTool lrcToolWithLrcName:model.
    [self loadTheData:model];
}
#pragma mark - 下一首音乐
- (void)nextMusic{
    [self removeAnimation];
    RankingListModel *model = [self.musicTool nextMusic];
    [self loadTheData:model];
}

#pragma mark -换曲时还原控件
- (void)removeAnimation{
    //暂停当前播放的音乐
    [self.manager pauseMusic];
    //移除动画
    [self.playMusicView.singerImageV.layer removeAllAnimations];
    [self.footerView.singerImageV.layer removeAllAnimations];
    
}

#pragma - mark 点击slider按下事件
- (void)dianJi{
    [self.manager removeTime];
}
#pragma - mark 点击slider抬起事件
- (void)dianJiEnd{
    //更新进度
    NSTimeInterval duration = self.playMusicView.playFooterView.progressBar.value* CMTimeGetSeconds(self.manager.avPlayer.currentItem.duration);
    CMTime seekTime = CMTimeMake(duration, 1);
    
    [self.manager.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
        
    }];
    [self.manager addTime];
}
#pragma - mark 拖动slider 更新播放进度
- (void)updateValue{
    //获得当前播放时间
    CMTime t = [self.manager.avPlayer currentTime];
    NSTimeInterval currentTimeSec = t.value / t.timescale;
    self.playMusicView.playFooterView.currentTime.text = [self.manager convertTime:currentTimeSec];
    
}


#pragma mark - 请求音乐数据
- (void)loadTheData:(RankingListModel *)model{
    [AFNTool GET:[NSString stringWithFormat:@"https://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=%@&platid=4&album_audio_id=%@&album_id=%@&dfid=2mSpmF1TpjFq0Iyi7r1WIEXY&appid=1014&mid=556cb26ec8411768000e1b515c7edd7d",model.hashId,model.album_audio_id,model.album_id] parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        MusicModel *model = [MusicModel mj_objectWithKeyValues:dict[@"data"]];
        //将当前歌词滚动到中间
        [self.playMusicView.playTableView setContentOffset:CGPointMake(0, -self.playMusicView.playTableView.bounds.size.height*0.5)];
        //解析歌词
        NSMutableArray * lrcModelAry = [self.musicTool lrcToolWithLrcName:model.lyrics];
        [self.playMusicView.playTableView reloadData];
        self.tableViewDelegate.lrcModelAry = lrcModelAry;
        self.manager.lrcModelAry = lrcModelAry;
        //更新UI
        self.playMusicView.model = model;
        self.footerView.model = model;
        //播放音乐
        [self.manager playMusicUrl:[NSURL URLWithString:model.play_url]];
        [self.manager playMusic];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

#pragma mark - 返回主界面
- (void)returnC{
    self.playMusicView.alpha = 0;
}

#pragma mark - 跳转播放界面
- (void)jumpViewController{
    self.playMusicView.alpha = 1;
}


#pragma mark - 播放／暂停音乐
- (void)playMusic{
    if (self.manager.stateOfPlay == YES) {
        [self.manager pauseMusic];
        self.manager.stateOfPlay = NO;
        [self.footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playMusicView.playFooterView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playMusicView.singerImageV.layer pauseAnimate];
        [self.footerView.singerImageV.layer pauseAnimate];
    }
    else{
        [self.manager playMusic];
        self.manager.stateOfPlay = YES;
        [self.footerView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pause_normal"] forState:UIControlStateNormal];
        [self.playMusicView.playFooterView.playBtn setImage:[UIImage imageNamed:@"landscape_player_btn_pause_normal"] forState:UIControlStateNormal];
        [self.playMusicView.singerImageV.layer resumeAnimate];
        [self.footerView.singerImageV.layer resumeAnimate];
    }
}
#pragma mark -searchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    SearchBarViewController *searchVC = [[SearchBarViewController alloc]init];
    searchVC.mlController = self;
    searchVC.playMusicView = self.playMusicView;
    searchVC.delegate = self.tableViewDelegate;
    [self presentViewController:searchVC animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
