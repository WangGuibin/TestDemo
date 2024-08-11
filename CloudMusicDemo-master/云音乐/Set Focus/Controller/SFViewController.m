//
//  SFViewController.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/20.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()
{
    NSUserDefaults *_user;
    //登录按钮
    UIButton *_dengLu;
    UIImageView *_imgView;
    //网名
    UILabel *_title;
}
@end

@implementation SFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _user = [NSUserDefaults standardUserDefaults];
    [self createUI];
    
//    if ([_user objectForKey:@"Image"] && [_user objectForKey:@"Name"]) {
//        _dengLu.alpha = 0;
//        [_imgView sd_setImageWithURL:[NSURL URLWithString:[_user objectForKey:@"Image"]]];
//        _title.text = [_user objectForKey:@"Name"];
//    }
//    else{
//
//
//    }
    
    
    // Do any additional setup after loading the view.
}

- (void)createUI{
    //登录按钮
    _dengLu = [[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.25, 100, 80, 80)];
    [self.view addSubview:_dengLu];
    [_dengLu setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [_dengLu addTarget:self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    //头像
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.25, 100, 80, 80 )];
    [self.view addSubview:_imgView];
    //设置圆角
    _imgView.layer.cornerRadius = 40;
    _imgView.layer.masksToBounds = YES;
    //网名
    _title = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.25-60, 190, 200, 30)];
    [self.view addSubview:_title];
    [_title setTextAlignment:NSTextAlignmentCenter];
}



@end
