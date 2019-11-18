//
//  WGBRepairedOrientationLabelDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBRepairedOrientationLabelDemoViewController.h"

@interface WGBRepairedOrientationLabelDemoViewController ()

@property (nonatomic, strong) WGBRepairedOrientationLabel *label;

@end

@implementation WGBRepairedOrientationLabelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.label.alignType = arc4random() % 13;
    
}

- (WGBRepairedOrientationLabel *)label {
    if (!_label) {
        _label = [[WGBRepairedOrientationLabel alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
        _label.text = @"只是一个测试文本";
        _label.backgroundColor = [UIColor orangeColor];
        [self.view addSubview: _label];
    }
    return _label;
}

@end
