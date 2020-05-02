//
// WGBAttentionListHeaderView.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/5/2
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
    

#import "WGBAttentionListHeaderView.h"

@interface WGBAttentionListHeaderView()

@property (nonatomic, strong) UIButton *focusListButton;
@property (nonatomic, strong) UIButton *fansListButton;
@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation WGBAttentionListHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       [self setupLayout];
        self.defaultSelectIndex = 0;
    }
    return self;
}

- (void)setupLayout{
    self.midLine.frame = CGRectMake(0, 0, 1 , 20);
    self.midLine.centerX = self.centerX;
    self.midLine.centerY = self.centerY;

    CGFloat btnW = (KWIDTH-1)/2.0;
    CGFloat btnH = 44;
    self.focusListButton.frame = CGRectMake(0, 0, btnW , btnH);
    self.focusListButton.centerY = self.centerY;
    self.fansListButton.frame = CGRectMake(CGRectGetMaxX(self.midLine.frame), 0, btnW , btnH);
    self.fansListButton.centerY = self.centerY;
    
    self.bottomLine.frame = CGRectMake(0, self.height - 1, self.width , 1);
    self.indicatorLine.frame = CGRectMake(0, self.height - 2, 40 , 2);
    self.indicatorLine.centerX = self.focusListButton.centerX;
}

- (void)setDefaultSelectIndex:(NSInteger)defaultSelectIndex{
    _defaultSelectIndex = defaultSelectIndex;
    if (defaultSelectIndex == 0) {
        [self clickBtnAction: self.focusListButton];
    }else if (defaultSelectIndex == 1){
        [self clickBtnAction: self.fansListButton];
    }
}



///MARK:- 点击按钮
- (void)clickBtnAction:(UIButton *)sender{
    if (sender.selected) {
        return ;
    }
    
    if (self.selectBtn) {
        self.selectBtn.selected = NO;
    }
    sender.selected = YES;
    self.selectBtn = sender;
    !self.clickButtonActionBlock? : self.clickButtonActionBlock(sender.tag);
    //更新指示器位置
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorLine.centerX = sender.centerX;
    }];
}

///MARK:- lazy load
- (UIButton *)focusListButton{
    if (!_focusListButton) {
        _focusListButton = [self createButton];
        _focusListButton.tag = 0;
        [_focusListButton addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_focusListButton setTitle:@"关注 (0)" forState:UIControlStateNormal];
        [_focusListButton setTitle:@"关注 (0)" forState:UIControlStateSelected];
        [self addSubview: _focusListButton];
    }
    return _focusListButton;
}

- (UIButton *)fansListButton{
    if (!_fansListButton) {
        _fansListButton = [self createButton];
        _fansListButton.tag = 1;
        [_fansListButton addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fansListButton setTitle:@"粉丝 (0)" forState:UIControlStateNormal];
        [_fansListButton setTitle:@"粉丝 (0)" forState:UIControlStateSelected];
        [self addSubview: _fansListButton];
    }
    return _fansListButton;
}

- (UIView *)midLine{
    if (!_midLine) {
        _midLine = [[UIView alloc] initWithFrame:CGRectZero];
        _midLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        [self addSubview:_midLine];
    }
    return _midLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = RGBA(241, 241, 241, 1.0);
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (UIView *)indicatorLine{
    if (!_indicatorLine) {
        _indicatorLine = [[UIView alloc] initWithFrame:CGRectZero];
        _indicatorLine.backgroundColor = [UIColor colorWithHexString:@"#FFC900"];
        [self addSubview:_indicatorLine];
    }
    return _indicatorLine;
}

- (UIButton *)createButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    return btn;
}


@end
