//
//  WGBWaveLayerButtonDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBWaveLayerButtonDemoViewController.h"

@interface WGBWaveLayerButtonDemoViewController ()

@end

@implementation WGBWaveLayerButtonDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    WGBWaveLayerButton *waveButton = [WGBWaveLayerButton buttonWithType:UIButtonTypeCustom];
    waveButton.frame = CGRectMake(0, 100, 300, 100);
    waveButton.center = CGPointMake(screenBounds.size.width/2.0, 300);
    waveButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];;
    waveButton.waveLayerColor = [UIColor orangeColor];//设置波纹的颜色
    [waveButton setTitle:@"Click Me" forState:UIControlStateNormal];
    [self.view addSubview:waveButton];

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
