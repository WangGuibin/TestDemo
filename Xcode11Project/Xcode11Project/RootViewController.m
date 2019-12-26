//
//  RootViewController.m
//  Xcode11Project
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    self.navigationItem.title = @"根控制器";
    self.button.frame = CGRectMake(100, 200, 150 , 30);
}

- (void)nextAction{
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:18];
        [_button setTitle:@"Next" forState:UIControlStateNormal];
         [_button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_button];
     }
    return _button;
}

@end
