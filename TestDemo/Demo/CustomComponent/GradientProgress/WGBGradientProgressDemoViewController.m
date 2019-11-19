//
//  GradientProgressDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBGradientProgressDemoViewController.h"
#import "WGBGradientProgressView.h"

@interface WGBGradientProgressDemoViewController ()

@property (nonatomic, strong) WGBGradientProgressView *progressView;

@end

@implementation WGBGradientProgressDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressView.frame = CGRectMake(10, 100,KWIDTH-20 , 6);
    self.progressView.progress = 0.25;
    self.progressView.layer.cornerRadius = 3.0f;
    self.progressView.layer.masksToBounds = YES;
    
    UIImage *progressImage = [[UIImage imageNamed:@"open_box_luck__progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:(UIImageResizingModeTile)];
    UIView *progressBg = [[UIView alloc] initWithFrame:CGRectMake(10, 130, KWIDTH-20 , 12)];
    progressBg.backgroundColor = [UIColor brownColor];
    [self.view addSubview: progressBg];
    UIImageView *progressView = [[UIImageView alloc] initWithImage:progressImage];
    progressView.frame = CGRectMake(0, 1, progressBg.width*0.5 , 10);
    [progressBg addSubview: progressView];
    ViewRadius(progressBg, 6);
    ViewRadius(progressView, 5);

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
