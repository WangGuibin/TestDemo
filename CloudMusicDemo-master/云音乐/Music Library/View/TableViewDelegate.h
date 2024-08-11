//
//  TableViewDelegate.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeftTableView.h"
#import "RightTableView.h"
#import "FooterView.h"
#import "MLViewController.h"
#import "LCZAVPlayer.h"
@interface TableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong) LeftTableView *leftTableView;
@property(nonatomic,strong) RightTableView *rightTableView;
@property(nonatomic,strong) FooterView *footerView;
@property(nonatomic,strong) MLViewController *mLViewController;
@property(nonatomic,strong) NSMutableArray *rankModelAry;
@property(nonatomic,strong) NSMutableArray *musicModelAry;
@property(nonatomic,strong) NSArray *leftAry;
@property(nonatomic,strong) LCZAVPlayer *manager;
@property(nonatomic,strong) NSMutableArray *lrcModelAry;
@end
