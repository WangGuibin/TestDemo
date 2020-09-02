//
// WGBDemoRefreshHeder.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/9/2
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
    

#import "WGBDemoRefreshHeder.h"


@implementation WGBDemoRefreshHeder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
        }];
        
        [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.tipsLabel.mas_left).offset(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
    }
    return self;
}


- (void)startAnimation{
    [self.HUD startAnimating];
    self.tipsLabel.text = @"正在加载...";
}

- (void)stopAnimation{
    [self.HUD stopAnimating];
    self.tipsLabel.text = @"下拉可以刷新数据";
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:18];
        _tipsLabel.text = @"下拉刷新";
        [self addSubview:_tipsLabel];
    }
    return  _tipsLabel;
}


- (UIActivityIndicatorView *)HUD {
    if (!_HUD) {
        _HUD = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _HUD.color = [UIColor whiteColor];
        [self addSubview:_HUD];
    }
    return _HUD;
}

@end
