//
//  YYTextDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YYTextDemoViewController.h"

@interface YYTextDemoViewController ()

@end

@implementation YYTextDemoViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(30, 100, 300 , 100)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor cyanColor];
    label.numberOfLines = 0;
    [self.view addSubview: label];
    
    NSString *redText = @"  #原创  ";
    NSString *totalText = @"  #原创   换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界换个角度看世界";
    
    // 1. 创建一个属性文本
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:totalText];
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 8;
    border.strokeWidth = 0.5;
    border.strokeColor = [UIColor blackColor];
    border.fillColor = [UIColor blackColor];
    border.insets = UIEdgeInsetsMake(0, 1, 0, 1);
    border.lineStyle = YYTextLineStyleSingle;
    
    //normal状态边框
    [text yy_setTextBackgroundBorder:border range:NSMakeRange(0, redText.length)];
    
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor redColor]];//高亮文字颜色
    [highlight setBackgroundBorder:border];
    //normal状态字体颜色
    [text yy_setColor:[UIColor whiteColor] range:NSMakeRange(0, redText.length)];
    //highlight状态边框和字体颜色
    [text yy_setTextHighlight:highlight range:NSMakeRange(0, redText.length)];

    //添加点击事件
    [highlight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"%@ - %@",text.string,NSStringFromCGRect(rect));
    }];
    label.attributedText = text;
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
