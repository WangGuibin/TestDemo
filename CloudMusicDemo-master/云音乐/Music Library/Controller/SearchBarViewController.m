//
//  SearchBarViewController.m
//  云音乐
//
//  Created by 刘超正 on 2017/10/29.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "SearchBarViewController.h"
#import "SearchCell.h"
#import "RankingListModel.h"
#import "MusicModel.h"
#import "CALayer+Aimate.h"
#import "LCZAVPlayer.h"
@interface SearchBarViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *searchTableView;
@property (nonatomic,strong) NSMutableArray *modelAry;//存储音乐模型
@property(nonatomic,strong) LCZAVPlayer *manager;//音乐播放管理

@end

@implementation SearchBarViewController
- (LCZAVPlayer *)manager{
    if (_manager == nil) {
        _manager = [LCZAVPlayer manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建搜索框
    [self createSearchBar];
    //创建表视图
    [self createTableView];
    //实例化可变数组。存储模型
    self.modelAry = [NSMutableArray array];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //获得第一响应者
//    [self.searchBar becomeFirstResponder];
//}
#pragma mark -搜索框
- (void)createSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,20 , kWidth, 30)];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索音乐";
    //隐藏search边框
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    //设置为取消样式
    [self.searchBar setShowsCancelButton:YES];
    //获得第一响应者
    [self.searchBar becomeFirstResponder];
}
#pragma mark -表视图
- (void)createTableView{
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.frame.size.height+30, kWidth, kHeight-self.searchBar.frame.size.height-30) style:UITableViewStylePlain];
    [self.view addSubview:self.searchTableView];
  //  self.searchTableView.backgroundColor = [UIColor purpleColor];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    [self.searchTableView registerClass:[SearchCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark -searchBarDelagate
//点击取消时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //返回MLViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击确认时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //请求网络音乐数据
    [self loadTheData:[NSString stringWithFormat:@"http://mobilecdn.kugou.com/api/v3/search/song?format=json&keyword=%@&page=1&pagesize=20&showtype=1",searchBar.text]];
    //取消第一响应者
    [searchBar resignFirstResponder];
}
#pragma mark -请求网络音乐数据
- (void)loadTheData:(NSString *)text{
    //参数有中文。需转码
    NSString *url = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [AFNTool GET:url parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSArray *ary = [RankingListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"info"]];
        for (RankingListModel *model in ary) {
            [self.modelAry addObject:model];
        }
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchTableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankingListModel *model = self.modelAry[indexPath.row];
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = model.filename;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前音乐模型
    RankingListModel *model = self.modelAry[indexPath.row];
    //请求音乐歌词数据
    [self loadTheDataLrc:[NSString stringWithFormat:@"https://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=%@&platid=4&album_audio_id=%@&album_id=%@&dfid=2mSpmF1TpjFq0Iyi7r1WIEXY&appid=1014&mid=556cb26ec8411768000e1b515c7edd7d",model.hashId,model.album_audio_id,model.album_id]];
}
#pragma mark - 请求音乐歌词数据
- (void)loadTheDataLrc:(NSString *)text{
    [AFNTool GET:text parameters:nil success:^(id result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        MusicModel *musicModel = [MusicModel mj_objectWithKeyValues:dict[@"data"]];
        //将当前歌词滚动到中间
        [self.playMusicView.playTableView setContentOffset:CGPointMake(0, -self.playMusicView.playTableView.bounds.size.height*0.5)];
        //解析歌词
        NSMutableArray * lrcModelAry = [self.mlController.musicTool lrcToolWithLrcName:musicModel.lyrics];
        //返回主线程 更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [self dismissViewControllerAnimated:YES completion:nil];
            self.delegate.lrcModelAry = lrcModelAry;
            self.manager.lrcModelAry = lrcModelAry;
            self.playMusicView.model = musicModel;
            //显示播放节目
            self.playMusicView.alpha = 1;
            self.mlController.footerView.model = musicModel;
            [self.playMusicView.playTableView reloadData];
            //播放音乐
            [self.manager playMusicUrl:[NSURL URLWithString:musicModel.play_url]];
            self.manager.mlViewController = self.mlController;
            [self.manager playMusic];
            
            
            
        });
        
    } failure:^(NSError *error) {
        
    }];
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
