//
//  WGBDemoViewController.m
//  WGBEasyMarqueeView_Example
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 Wangguibin. All rights reserved.
//

#import "WGBDemoViewController.h"
#import "WGBCustomView.h"

@interface WGBDemoViewController ()

@property (nonatomic,strong) WGBEasyMarqueeView *marqueeView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) WGBCustomView *customView;
@end

@implementation WGBDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    WGBEasyMarqueeView *marqueeView = [[WGBEasyMarqueeView alloc] init];
    marqueeView.backgroundColor = [UIColor lightGrayColor];
    marqueeView.contentMargin = 50;
    marqueeView.speed = 1.5f;
    [self.view addSubview: marqueeView];
    if (self.marqueeType != 3) {
        marqueeView.marqueeType = self.marqueeType;
        marqueeView.contentView = self.label;
    }else{
        marqueeView.marqueeType = WGBEasyMarqueeTypeReverse;
        marqueeView.contentView = self.customView;
    }
    self.marqueeView = marqueeView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.marqueeView.bounds = CGRectMake(0, 0, 300 , 60);
    self.marqueeView.center = self.view.center;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


///MARK:- Lazy load
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = @"中国日报网9月24日电（高琳琳） 今年6月，当美国第一夫人梅拉尼娅·特朗普的发言人斯蒂芬妮·格里沙姆被任命为新一任白宫新闻秘书时，很多人都在猜测白宫的每日例行新闻简报会是否会重启。";
        _label.textColor = [UIColor redColor];
    }
    return _label;
}

- (WGBCustomView *)customView{
    if (!_customView) {
        _customView = [[WGBCustomView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    }
    return _customView;
}


@end
