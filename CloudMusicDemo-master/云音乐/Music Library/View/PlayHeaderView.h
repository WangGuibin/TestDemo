//
//  PlayHeaderView.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayHeaderView : UIView

@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UILabel *author;
@property(nonatomic,strong) UIButton *returnBtn;

+ (instancetype)initWithPlayHeaderView:(CGRect)frame;
@end
