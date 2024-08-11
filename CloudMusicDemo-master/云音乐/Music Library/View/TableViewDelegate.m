//
//  TableViewDelegate.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "TableViewDelegate.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
//#import "AFNTool.h"
#import "RankingListModel.h"
#import "MusicModel.h"
#import "LRCTableViewCell.h"
#import "LrcModel.h"
@implementation TableViewDelegate

- (NSMutableArray *)musicModelAry{
    if (_musicModelAry == nil) {
        _musicModelAry = [NSMutableArray array];
    }
    return _musicModelAry;
}

- (NSArray *)leftAry{
    if (_leftAry == nil) {
        _leftAry = [NSArray arrayWithObjects:@"酷狗TOP500",@"酷狗飙升榜",@"网络红歌榜",@"DJ热歌榜",@"华语新歌榜",@"欧美新歌榜",@"韩国新歌榜",@"日本新歌版",@"粤语新歌榜",@"校园歌曲榜", nil];
    }
    return _leftAry;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.leftTableView == tableView) {
        return self.leftAry.count;
    }
    else if (tableView == self.rightTableView)
    {
        return self.rankModelAry.count;
    }
    else{
        return self.lrcModelAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        LeftTableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
        leftCell.TheSongList.text = self.leftAry[indexPath.row];
        leftCell.backgroundColor = LCZColor(244, 244, 244,1);
        //自定义选中时的背景颜色 和字体颜色
        leftCell.selectedBackgroundView = [[UIView alloc]initWithFrame:leftCell.frame];
        leftCell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        leftCell.TheSongList.highlightedTextColor = LCZColor(48, 195, 124,1);
        //默认选中第一个单元格
        if (indexPath.row == 0) {
            [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        return leftCell;
    }
    else if (tableView == self.rightTableView)
    {
        RightTableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
        RankingListModel *model = self.rankModelAry[indexPath.row];
       // NSLog(@"%@",model.filename);
        rightCell.title.text = model.filename;
        rightCell.rankLbl.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        //设置前三名的排名为红色
        if (indexPath.row<3) {
            rightCell.rankLbl.textColor = [UIColor redColor];
        }
        else{
            rightCell.rankLbl.textColor = [UIColor blackColor];
        }
        return rightCell;
    }
    else{
         LRCTableViewCell *lrcCell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell" forIndexPath:indexPath];
        lrcCell.backgroundColor = [UIColor clearColor];
        lrcCell.selectionStyle = UITableViewCellSelectionStyleNone;
        lrcCell.lrcLbl.font = [UIFont systemFontOfSize:14];
        lrcCell.lrcLbl.textColor = [UIColor whiteColor];
        lrcCell.lrcLbl.textAlignment = NSTextAlignmentCenter;
        LrcModel *model = self.lrcModelAry[indexPath.row];
        lrcCell.lrcLbl.text = model.text;
        LCZAVPlayer *manager = [LCZAVPlayer manager];
        if (manager.currentIndex == indexPath.row) {
            lrcCell.lrcLbl.font = [UIFont systemFontOfSize:20];
        }
        else{
            lrcCell.lrcLbl.font = [UIFont systemFontOfSize:14];
            lrcCell.lrcLbl.pross = 0;
        }
        return lrcCell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        if (indexPath.row == 0) {
            [self TheRequestData:CoolDogSlipped];
        }
        else if (indexPath.row == 1){
            [self TheRequestData:CoolDogList];
        }
        else if (indexPath.row == 2){
            [self TheRequestData:ListOfInternetRedSongs];
        }
        else if (indexPath.row == 3){
            [self TheRequestData:DJHotSongList];
        }
        else if (indexPath.row == 4){
            [self TheRequestData:ChineseNewSongsList];
        }
        else if (indexPath.row == 5){
            [self TheRequestData:NewSongs];
        }
        else if (indexPath.row == 6){
            [self TheRequestData:NewSongList];
        }
        else if (indexPath.row == 7){
            [self TheRequestData:Nippon];
        }
        else if (indexPath.row == 8){
            [self TheRequestData:ANewListOfCantoneseSongs];
        }
        else{
            [self TheRequestData:CampusSongList];
        }
    }
    else if (tableView == self.rightTableView)
    {
        //获取歌曲详情
        RankingListModel *model = self.rankModelAry[indexPath.row];
        NSInteger index = indexPath.row;
        //给音乐管理类传入当前索引
        self.mLViewController.musicTool.index = index;
        [self RequestForSongDetails:model];
        
    }
    else{
        
    }
    
}

- (void)TheRequestData:(NSString *)url{
    //请求前先清空数组
    [self.rankModelAry removeAllObjects];
    [AFNTool GET:url parameters:nil success:^(id result) {
        NSString *dataStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"data:\n%@",dataStr);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSArray *jsonAry = [RankingListModel mj_objectArrayWithKeyValuesArray:dict[@"songs"][@"list"]];
        for (RankingListModel *model in jsonAry) {
            [self.rankModelAry addObject:model];
        }
        //传值给音乐工具类。
        self.mLViewController.musicTool.musicModelAry = self.rankModelAry;
        [self.rightTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 请求歌曲详情
- (void)RequestForSongDetails:(RankingListModel *)model
{
   [self.musicModelAry removeAllObjects];
    
//https://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=38698C9A8BB6637CDDE413C6E210FA54&platid=4&album_audio_id=89488966&album_id=4128050&dfid=2mSpmF1TpjFq0Iyi7r1WIEXY&appid=1014&mid=556cb26ec8411768000e1b515c7edd7d
    
   [AFNTool GET:[NSString stringWithFormat:@"https://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=%@&platid=4&album_audio_id=%@&album_id=%@&dfid=2mSpmF1TpjFq0Iyi7r1WIEXY&appid=1014&mid=556cb26ec8411768000e1b515c7edd7d",model.hashId,model.album_audio_id,model.album_id] parameters:nil success:^(id result) {
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
       MusicModel *musicModel = [MusicModel mj_objectWithKeyValues:dict[@"data"]];
       //将当前歌词滚动到中间
       [self.mLViewController.playMusicView.playTableView setContentOffset:CGPointMake(0, -self.mLViewController.playMusicView.playTableView.bounds.size.height*0.5)];
       //解析歌词
       self.lrcModelAry = [self.mLViewController.musicTool lrcToolWithLrcName:musicModel.lyrics];
       [self.mLViewController.playMusicView.playTableView reloadData];
       //更新主控制器UI
       self.mLViewController.footerView.model = musicModel;
       //播放管理类
       self.manager = [LCZAVPlayer manager];
       [self.manager playMusicUrl:[NSURL URLWithString:musicModel.play_url]];
       self.manager.lrcModelAry = self.lrcModelAry;
       //传值 更新UI
       self.manager.mlViewController = self.mLViewController;
       //跳转播放控制器 传值
       self.mLViewController.playMusicView.model = musicModel;
       self.mLViewController.playMusicView.alpha = 1;
       //播放音乐
       [self.manager playMusic];
       
       
       
   } failure:^(NSError *error) {
       
   }];
}

#pragma ScrollView 代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //因为tableView和scrollView都会调用此方法。所以需要判断
    if (scrollView == self.mLViewController.playMusicView.playScrollView) {
        //获取滚动的偏移量
        CGPoint point = scrollView.contentOffset;
        //获取滑动比例
        CGFloat alpha = 1 - point.x / scrollView.bounds.size.width;
        //设置alpha
        self.mLViewController.playMusicView.singerImageV.alpha = alpha;
        self.mLViewController.playMusicView.lrcLbl.alpha = alpha;
    }
    
}
@end
