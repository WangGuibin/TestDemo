//
//  SearchBarViewController.h
//  云音乐
//
//  Created by 刘超正 on 2017/10/29.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLViewController.h"
#import "PlayMusicView.h"
#import "TableViewDelegate.h"
@interface SearchBarViewController : UIViewController
@property (nonatomic,strong) MLViewController *mlController;
@property (nonatomic,strong) PlayMusicView *playMusicView;
@property (nonatomic,strong) TableViewDelegate *delegate;
@end
