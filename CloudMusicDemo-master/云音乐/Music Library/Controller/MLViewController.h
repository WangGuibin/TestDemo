//
//  MLViewController.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/20.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "FooterView.h"
#import "LCZMusicTool.h"
#import "PlayMusicView.h"
@interface MLViewController : UIViewController
@property (nonatomic,strong) HeaderView *headerView;//头部View
@property (nonatomic,strong) FooterView *footerView;//尾部View
@property(nonatomic,strong) LCZMusicTool *musicTool;//音乐工具
@property(nonatomic,strong) PlayMusicView *playMusicView;//播放音乐视图

#pragma mark - 上一首音乐
- (void)previousMusic;

#pragma mark - 下一首音乐
- (void)nextMusic;
@end
