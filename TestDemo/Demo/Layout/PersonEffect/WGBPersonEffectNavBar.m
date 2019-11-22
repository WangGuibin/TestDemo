//
// WGBPersonEffectNavBar.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/22
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
    

#import "WGBPersonEffectNavBar.h"

@implementation WGBPersonEffectNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.mas_top).offset(kStatusBarHeight - 5);
        make.size.mas_equalTo(CGSizeMake(30, 44));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(-10);
        make.centerY.equalTo(self.backButton);
    }];
    
    [self.carEntranceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18);
        make.size.mas_equalTo(CGSizeMake(90, 26));
        make.centerY.equalTo(self.titleLabel);
    }];
    ViewRadius(self.carEntranceButton, 13);
}


///MARK:- 返回
- (void)backAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBackAction)]) {
        [self.delegate goBackAction];
    }
}

///MARK:- 查看他的车友圈
- (void)watchCarCycleAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchCarFriendCycleAction)]) {
        [self.delegate watchCarFriendCycleAction];
    }
}

///MARK:- Lazy load
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"payzone_content_detail_bg"];
        [self addSubview: _bgImageView];
    }
    return _bgImageView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_white_back"] forState:UIControlStateNormal];
        _backButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: _backButton];
    }
    return _backButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"宇宙最强工作室";
        _titleLabel.font = KFontSize(24);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)carEntranceButton{
    if (!_carEntranceButton) {
        _carEntranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carEntranceButton setTitle:@"TA的车友圈" forState:UIControlStateNormal];
        _carEntranceButton.titleLabel.font = KFontSize(12);
        _carEntranceButton.backgroundColor = RGBA(255, 255, 255, 0.2);
        [_carEntranceButton addTarget:self action:@selector(watchCarCycleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_carEntranceButton];
    }
    return _carEntranceButton;
}
@end
