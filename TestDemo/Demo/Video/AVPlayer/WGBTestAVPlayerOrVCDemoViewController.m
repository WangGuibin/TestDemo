//
// WGBTestAVPlayerOrVCDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/10
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBTestAVPlayerOrVCDemoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#define kVideoURLString @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4"

@interface WGBTestAVPlayerOrVCDemoViewController ()

@property (nonatomic, strong) AVPlayer *player ;
@property (nonatomic, strong) UIView *palyerView;

@end

@implementation WGBTestAVPlayerOrVCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:kVideoURLString]];
    [player play];
    self.player = player;

    AVPlayerLayer *preViewLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    preViewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300 , 300)];
    view.backgroundColor = [UIColor blackColor];
    view.centerX = KWIDTH/2.0f;
    view.layer.cornerRadius = 10.0f;
    view.layer.masksToBounds = YES;
    preViewLayer.frame = view.bounds;
    [view.layer addSublayer:preViewLayer];
    [self.view addSubview:view];
    self.palyerView = view;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(0, 450, 200 , 30);
    button.centerX = KWIDTH/2.0f;
    [button setTitle:@"打开控制器播放" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//
//    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
//    playerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:kVideoURLString]];
//    playerVC.showsPlaybackControls = NO;
//    playerVC.view.frame = CGRectMake(0, 500, 300 , 300);
//    playerVC.view.centerX = KWIDTH/2.0f;
//    [playerVC.player play];
//    [self.view addSubview:playerVC.view];
    
}

- (void)clipAction{
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:kVideoURLString]];
    playerVC.player = player;
    [player play];
    [self presentViewController:playerVC animated:YES completion:nil];
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
