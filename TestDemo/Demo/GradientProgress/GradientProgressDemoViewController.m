//
//  GradientProgressDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GradientProgressDemoViewController.h"
#import "WGBGradientProgressView.h"

@interface GradientProgressDemoViewController ()

@property (nonatomic, strong) WGBGradientProgressView *progressView;

@end

@implementation GradientProgressDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressView.frame = CGRectMake(10, 100,KWIDTH-20 , 6);
    self.progressView.progress = 0.25;
    self.progressView.layer.cornerRadius = 3.0f;
    self.progressView.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent: event];
    self.progressView.progress += 0.05;
}


- (WGBGradientProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WGBGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, 300 , 6)];
        [self.view addSubview: _progressView];
    }
    return _progressView;
}

@end
