//
// WGBGoodsCartDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/11/15
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
    

#import "WGBGoodsCartDemoViewController.h"

@interface WGBGoodsCartDemoViewController ()

@property (nonatomic, strong) UIImageView *bigImgView;
@property (nonatomic, strong) UIImageView *smallImgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) NSInteger count;

@end

@implementation WGBGoodsCartDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(executeAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"清空" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 addTarget:self action:@selector(clearCart) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems  = @[[[UIBarButtonItem alloc] initWithCustomView:button],[[UIBarButtonItem alloc] initWithCustomView:button1]];
    self.bigImgView.frame = CGRectMake(40, kNavBarHeight+20, KWIDTH-80 , 400);
    [self smallImgView];
    
}

- (void)clearCart{
    self.count = 0;
    self.textLabel.text = @"0";
    self.smallImgView.image = nil;
}


- (void)executeAnimation:(UIButton *)sender{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    __block UIImageView *tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape"]]; //实际操作可以截屏获取到View进行动画操作 UIView动画不太平滑 轨迹有些突兀或者太快了 
    
    tempView.frame = CGRectInset(self.bigImgView.frame, 30, 30);
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    [self.view addSubview:tempView];
    [UIView animateWithDuration:0.35 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        CGRect rect = tempView.frame;
        rect.size = CGSizeMake(80, 80);
        rect.origin.x = (self.bigImgView.frame.origin.x + self.bigImgView.frame.size.width/2.0 - 40);
        rect.origin.y = (self.bigImgView.frame.origin.y + self.bigImgView.frame.size.height/2.0 - 40);
        tempView.frame = rect;
        tempView.layer.cornerRadius = 40;
        tempView.layer.masksToBounds = YES;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 delay:0.15 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            tempView.center = self.smallImgView.center;
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
            self.smallImgView.image = [UIImage imageNamed:@"landscape"];
            self.count ++;
            self.textLabel.text = @(self.count).stringValue;
        }];
    }];

}


- (UIImageView *)bigImgView {
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape"]];
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_bigImgView];
    }
    return _bigImgView;
}

- (UIImageView *)smallImgView {
    if (!_smallImgView) {
        _smallImgView = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH-100, KHIGHT-120, 80 , 80)];
        _smallImgView.contentMode = UIViewContentModeScaleAspectFill;
        _smallImgView.clipsToBounds = YES;
        _smallImgView.backgroundColor = [UIColor orangeColor];
        _smallImgView.layer.cornerRadius = 40.0f;
        _smallImgView.layer.masksToBounds = YES;
        [self.view addSubview:_smallImgView];
    }
    return _smallImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80 , 80)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor redColor];
        _textLabel.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
        [self.smallImgView addSubview:_textLabel];
    }
    return  _textLabel;
}

@end
