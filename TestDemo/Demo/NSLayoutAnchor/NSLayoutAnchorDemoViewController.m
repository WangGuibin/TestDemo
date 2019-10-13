//
//  NSLayoutAnchorDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSLayoutAnchorDemoViewController.h"

@interface NSLayoutAnchorDemoViewController ()

@end

@implementation NSLayoutAnchorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectZero];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview: redView];
    
    NSLayoutConstraint *leftCos;
    NSLayoutConstraint *rightCos;
    NSLayoutConstraint *heightCos;
    NSLayoutConstraint *centerYCos;
    
    //关键 不设置为NO的话 约束会不生效
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    
    leftCos  =  [redView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50];
    rightCos =  [redView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50];
    heightCos = [redView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5];
    centerYCos = [redView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];
    
    //设置约束生效
    [@[leftCos,rightCos,heightCos,centerYCos] map:^id(NSLayoutConstraint *value) {
        value.active = YES;
        return value;
    }];
    
    //update 一个布局约束需要先取消 比如修改高度约束
    heightCos.active = NO;
    heightCos = [redView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.25];
    heightCos.active = YES;
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
