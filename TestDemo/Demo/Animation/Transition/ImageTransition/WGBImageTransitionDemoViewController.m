//
// WGBImageTransitionDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/20
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
    

#import "WGBImageTransitionDemoViewController.h"

@interface WGBImageTransitionDemoViewController ()

@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *changeImageButton;

@end

@implementation WGBImageTransitionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.bannerImageView.image = [UIImage imageNamed:@"cat.jpg"];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBarHeight+20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(150);
    }];
    
    [self.changeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImageView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.centerX.equalTo(self.view);
    }];
}

///更换图片
- (void)changeImageAction{
    [self testCATransition];
//    [self testUIViewAnimation];
}

- (void)testCATransition{
    CATransition *transition = [CATransition wgb_createTransitionWithAnimationType:(arc4random()%12) subType:(arc4random()%4) duration:0.5];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.bannerImageView.layer addAnimation:transition forKey:nil];
    self.changeImageButton.selected = !self.changeImageButton.selected;
    NSString *imageName = self.changeImageButton.selected? @"payzone_content_detail_bg":@"cat.jpg";
    self.bannerImageView.image = [UIImage imageNamed:imageName];
}

- (void)testUIViewAnimation{
        //截图做动画
        UIView *snaptImageView = [self.bannerImageView snapshotViewAfterScreenUpdates:YES];
        [self.bannerImageView addSubview:snaptImageView];
        snaptImageView.frame = self.bannerImageView.bounds;

        //切换图片
        self.changeImageButton.selected = !self.changeImageButton.selected;
        NSString *imageName = self.changeImageButton.selected? @"payzone_content_detail_bg":@"cat.jpg";
        //淡入淡出图片动画
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut animations:^{
            self.bannerImageView.image = [UIImage imageNamed:imageName];
    //        snaptImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            if (arc4random()%2) {
                snaptImageView.transform = CGAffineTransformMakeTranslation(arc4random()%2?KWIDTH:-KWIDTH, 0);
            }else{
                snaptImageView.transform = CGAffineTransformMakeTranslation(0, arc4random()%2?150:-150);
            }
    //        CGRect rect = snaptImageView.frame ;
    //        rect.origin.y = rect.origin.y + 150;
    //        rect.origin.x = rect.origin.x - KWIDTH;
    //        snaptImageView.frame = rect;
            snaptImageView.alpha = 0.01;
        } completion:^(BOOL finished) {
            snaptImageView.transform = CGAffineTransformIdentity;
            [snaptImageView removeFromSuperview];
        }];
}


///MARK:- lazy load
- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithImage:nil];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.clipsToBounds = YES;
        [self.view addSubview:_bannerImageView];
    }
    return _bannerImageView;
}

- (UIButton *)changeImageButton {
    if (!_changeImageButton) {
        _changeImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeImageButton.backgroundColor = [UIColor blackColor];
        _changeImageButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_changeImageButton setTitle:@"更换图片" forState:UIControlStateNormal];
         [_changeImageButton addTarget:self action:@selector(changeImageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _changeImageButton];
     }
    return _changeImageButton;
}

@end
