//
//  ViewController.m
//  TwitterListDemo
//
//  Created by 曹学亮 on 2017/11/27.
//  Copyright © 2017年 Cao Xueliang. All rights reserved.
//

#import "ViewController.h"
#import "MLTweetLayouts.h"
#import "TwitterCell.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"

@interface ViewController ()<TwitterCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTable;
@property (nonatomic,strong) NSMutableArray *layoutsArray;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"首页";
    
    [self.view addSubview:self.myTable];
    self.myTable.frame = self.view.bounds;
    [self getData];
    YYFPSLabel *fps = [[YYFPSLabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 100, 55 , 25)];
    [self.view addSubview:fps];
    
}

#pragma mark - UITableView M
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"MLTweetCell";
    TwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TwitterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:self.layoutsArray[indexPath.row]];
    cell.statusView.layout.selectIndex = indexPath.row;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((MLTweetLayouts *)self.layoutsArray[indexPath.row]).totalHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Cell Delegate
///点击了 Cell
- (void)cellDidClick:(TwitterCell *)cell{
    NSLog(@"点击了cell");
}

///点击了Cell菜单
- (void)cellDidClickMenu:(TwitterCell *)cell{
    NSLog(@"点击了cell菜单");
}

///点击了展开收起按钮
- (void)cellDidClickExpendButton:(TwitterCell *)cell{
    MLTweetLayouts *tweetLayout = cell.statusView.layout;
    if (!tweetLayout.tweetModel.news_id) {
        return;
    }
    
    MLTweetLayouts *squareLayout = self.layoutsArray[tweetLayout.selectIndex];
    squareLayout.isExpend = !squareLayout.isExpend;
    [squareLayout layout];
    [self.myTable reloadData];
}

///点击了视频
- (void)cellDidClickedVideo:(TwitterCell *)cell{
    NSLog(@"点击了视频");
}

///点击了关注
- (void)cellDidClickFollow:(TwitterCell *)cell{
    NSLog(@"点击了关注");
}

///点击了转发
- (void)cellDidClickRepost:(TwitterCell *)cell{
    NSLog(@"点赞");
}

//点击了点赞的昵称
- (void)cellDidClickedLikedUser:(TweetLikeModel *)userModel{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:userModel.nick_name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确实" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:NULL];
}

///点击了评论的昵称
- (void)cellDidClickedCommentUser:(TweetCommentModel *)userModel{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:userModel.nick_name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确实" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:NULL];
}

///点击了回复人的昵称
- (void)cellDidClickedReplyUser:(NSString *)memberId{
    NSLog(@"回复人id:%@",memberId);
}

///点击了评论
- (void)cellDidClickComment:(TwitterCell *)cell{
    NSLog(@"评论");
}

///评论评论中的内容
- (void)cellDidClickedCommentListCell:(TwitterCell *)cell commentIndex:(NSInteger)index{
    
}

///点击了赞
- (void)cellDidClickLike:(TwitterCell *)cell{
    NSLog(@"分享");
}

///点击了用户
- (void)cell:(TwitterCell *)cell didClickUser:(MLTweetModel *)user{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:user.nick_name preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确实" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:NULL];
}

///点击了图片
- (void)cell:(TwitterCell *)cell didClickImageAtIndex:(NSUInteger)index{
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    MLTweetModel *status = cell.statusView.layout.tweetModel;
    if (!status.news_id) {
        return;
    }
    NSArray<TweetPictureModel *> *pics = status.tweetPictureArray;
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        
        TweetPictureModel *pic = pics[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:pic.images_big];
        //item.largeImageSize = CGSizeMake(pic.ico_width, pic.ico_height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    v.blurEffectBackground = NO;
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(TwitterCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    if (info[kWBLinkURLName]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info[kWBLinkURLName]]];
        
    }else if (info[KWBLinkPhone]){
        NSMutableString *str2=[[NSMutableString alloc] initWithFormat:@"tel:%@",info[KWBLinkPhone]];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str2]]];
        [self.view addSubview:callWebview];
    }
}

#pragma mark - Setter && Getter
- (NSMutableArray *)layoutsArray{
    if (!_layoutsArray) {
        _layoutsArray = [[NSMutableArray alloc]init];
    }
    return _layoutsArray;
}

- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [UITableView new];;
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTable.showsVerticalScrollIndicator = NO;
        _myTable.tableFooterView = [UIView new];
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTable;
}

- (void)getData{
    NSData *data = [NSData dataNamed:@"dynamic.json"];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *arr = dictionary[@"return_data"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *entryDict = obj;
        MLTweetModel *tweetModel = [MLTweetModel yy_modelWithJSON:entryDict];
        MLTweetLayouts *layout = [[MLTweetLayouts alloc]initWithStatus:tweetModel isDeatil:NO];
        //只显示能看到的动态
        if ([tweetModel.nosee isEqualToString:@"N"]) {
            [self.layoutsArray addObject:layout];
        }
    }];
    [self.myTable reloadData];
}

@end
