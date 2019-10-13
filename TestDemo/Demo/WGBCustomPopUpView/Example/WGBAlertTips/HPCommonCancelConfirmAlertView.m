//
//  HPCommonCancelConfirmAlertView.m
//  DY-ios
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019 YGC. All rights reserved.
//

#import "HPCommonCancelConfirmAlertView.h"

@interface HPCommonCancelConfirmAlertView()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (nonatomic, strong) CALayer *stackBgLayer;

@end


@implementation HPCommonCancelConfirmAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.leftButton.backgroundColor = [UIColor whiteColor];
    self.rightButton.backgroundColor = [UIColor whiteColor];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.stackBgLayer.frame = self.stackView.bounds;
}



- (void)setMessage:(NSString *)message{
    _message = message;
    self.tipsLabel.text = message;
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle{
    _leftButtonTitle = leftButtonTitle;
    [self.leftButton setTitle: leftButtonTitle forState: UIControlStateNormal];
    self.leftButton.hidden = NO;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle{
    _rightButtonTitle = rightButtonTitle;
    [self.rightButton setTitle: rightButtonTitle forState:UIControlStateNormal];
    self.rightButton.hidden = NO;
}

// 0 left  1 right
- (IBAction)clickButtonAction:(UIButton *)sender {
    !self.clickButtonActionBlock? : self.clickButtonActionBlock(sender.tag);
}


- (CALayer *)stackBgLayer {
    if (!_stackBgLayer) {
        _stackBgLayer = [[CALayer alloc] init];
        _stackBgLayer.backgroundColor = RGB(238, 238, 238).CGColor;
        [self.stackView.layer insertSublayer:_stackBgLayer atIndex:0];
    }
    return _stackBgLayer;
}

@end
