//
//  WGBRewardAlertView.m
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 cool. All rights reserved.
//
/**
 *
 *                #####################################################
 *                #                                                   #
 *                #                       _oo0oo_                     #
 *                #                      o8888888o                    #
 *                #                      88" . "88                    #
 *                #                      (| -_- |)                    #
 *                #                      0\  =  /0                    #
 *                #                    ___/`---'\___                  #
 *                #                  .' \\|     |# '.                 #
 *                #                 / \\|||  :  |||# \                #
 *                #                / _||||| -:- |||||- \              #
 *                #               |   | \\\  -  #/ |   |              #
 *                #               | \_|  ''\---/''  |_/ |             #
 *                #               \  .-\__  '-'  ___/-. /             #
 *                #             ___'. .'  /--.--\  `. .'___           #
 *                #          ."" '<  `.___\_<|>_/___.' >' "".         #
 *                #         | | :  `- \`.;`\ _ /`;.`/ - ` : | |       #
 *                #         \  \ `_.   \_ __\ /__ _/   .-` /  /       #
 *                #     =====`-.____`.___ \_____/___.-`___.-'=====    #
 *                #                       `=---='                     #
 *                #     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #
 *                #                                                   #
 *                #               佛祖保佑         永无BUG              #
 *                #                                                   #
 *                #####################################################
 */

#import "WGBRewardAlertView.h"

@interface WGBRewardAlertView()

@property (nonatomic,strong) UIView *alertBodyView;
@property (nonatomic,strong) UIImageView *topIconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *moneyInputBgView;
@property (nonatomic,strong) UILabel *unitLabel;
@property (nonatomic,strong) UITextField *inputTextField;

@property (nonatomic,strong) UIView *messageInputBgView;
@property (nonatomic,strong) UITextField *messageTextView;

@property (nonatomic,strong) UILabel *balanceLabel;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *cancelButton;

@end

@implementation WGBRewardAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self monitorBalanceEventsAction];
//        self.balanceValue = 100.00; //先假设有100块 用于测试弹窗
    }
    return self;
}

///MARK:- Interaction
- (void)monitorBalanceEventsAction{
    @weakify(self);
    [self.inputTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        double number = [x doubleValue];
        BOOL canPay = number <= self.balanceValue;
        NSString *buttonTitle = canPay? @"好，赏了": @"余额不足，立即充值";
        UIColor *moneyBgColor = canPay? RGB(245, 245, 245):RGB(255, 221, 221);
        [self.confirmButton setTitle: buttonTitle forState: UIControlStateNormal];
        self.moneyInputBgView.backgroundColor = moneyBgColor;
    }];
    
    [[kNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary * info= [x userInfo];
        CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.alertBodyView.y = KHIGHT - keyboardHeight - self.alertBodyView.height - self.topIconImageView.height/2.0;
        }];
    }];
    
    [[kNotificationCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [UIView animateWithDuration:0.25 animations:^{
            self.alertBodyView.centerY = self.height/2.0;
        }];
    }];
}


///MARK:- Events CallBack
- (void)confirmAction:(UIButton *)sender{
    [self endEditing:YES];
    BOOL canPay = [sender.currentTitle isEqualToString:@"好，赏了"];
    !self.confirmBlock? : self.confirmBlock(canPay,self.inputTextField.text,self.messageTextView.text);
}

- (void)cancelAction:(UIButton *)sender{
    [self endEditing:YES];
    !self.cancelBlock? : self.cancelBlock();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

///MARK；- Builded UI
- (void)setup{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    CGFloat scale = (KWIDTH/414.0f);
    CGFloat leftRightSpace = 63*scale;
    CGFloat bodyW = viewWidth - leftRightSpace*2;
    if (KWIDTH <= 320) {
        bodyW = 300;
    }
    CGFloat bodyH = 400;
    self.alertBodyView.frame = CGRectMake(0, 0, bodyW , bodyH);
    self.alertBodyView.centerX = viewWidth/2.0;
    self.alertBodyView.centerY = viewHeight/2.0;
    self.alertBodyView.layer.cornerRadius = 10.0f;
    
    CGFloat topIconWH = 60;
    self.topIconImageView.frame = CGRectMake(0, 0, topIconWH , topIconWH);
    self.topIconImageView.centerY = 0;
    self.topIconImageView.centerX = bodyW/2.0f;
    
    CGFloat margin = 15;
    CGFloat titleH = 21;
    CGFloat titleW = bodyW;
    CGFloat titleY = CGRectGetMaxY(self.topIconImageView.frame) + margin;
    self.titleLabel.frame = CGRectMake(0, titleY, titleW , titleH);
    
    CGFloat inputLeftSpace = 20;
    CGFloat inputRightftSpace = inputLeftSpace;
    CGFloat inputBgHeight = 45;
    CGFloat inputBgWidth = bodyW - inputLeftSpace - inputRightftSpace;
    CGFloat moneyInputBgY = CGRectGetMaxY(self.titleLabel.frame) + 20;
    self.moneyInputBgView.frame = CGRectMake(inputLeftSpace, moneyInputBgY, inputBgWidth, inputBgHeight);
    
    CGFloat messageTextBgY = 10 + CGRectGetMaxY(self.moneyInputBgView.frame);
    self.messageInputBgView.frame = CGRectMake(inputLeftSpace, messageTextBgY, inputBgWidth, inputBgHeight);
    
    
    CGFloat unitX = inputBgWidth - 30;
    self.unitLabel.frame = CGRectMake(unitX, 0, 30 , 21);
    [self.unitLabel sizeToFit];
    self.unitLabel.centerY = inputBgHeight/2.0;
    
    CGFloat moneyX = 15;
    CGFloat moneyW = inputBgWidth - self.unitLabel.width - moneyX - 60;
    CGFloat moneyH = inputBgHeight;
    self.inputTextField.frame = CGRectMake(moneyX, 0, moneyW , moneyH);
    self.messageTextView.frame = CGRectMake(5,5, inputBgWidth - 10 , inputBgHeight - 10);
    
    CGFloat balanceY = CGRectGetMaxY(self.messageInputBgView.frame) + 15;
    self.balanceLabel.frame = CGRectMake(0, balanceY, bodyW , 25);
    
    CGFloat buttonSpace = 50;
    CGFloat buttonW = bodyW - buttonSpace*2;
    CGFloat buttonH = 45;
    CGFloat confirmBtnY = CGRectGetMaxY(self.balanceLabel.frame) + 15;
    self.confirmButton.frame = CGRectMake(buttonSpace, confirmBtnY, buttonW , buttonH);
    
    CGFloat cancelBtnY = CGRectGetMaxY(self.confirmButton.frame) + 20;
    CGFloat cancelBtnH = 30;
    self.cancelButton.frame = CGRectMake(buttonSpace, cancelBtnY, buttonW , cancelBtnH);
    self.alertBodyView.height = CGRectGetMaxY(self.cancelButton.frame) + 25;
}


///MARK；- setter
- (void)setBalanceValue:(CGFloat)balanceValue{
    _balanceValue = balanceValue;
//    @"余额:¥3.55"
    self.balanceLabel.text = [NSString stringWithFormat:@"余额:¥%.2f",balanceValue];
}

///MARK:- getter
- (UIView *)alertBodyView{
    if (!_alertBodyView) {
        _alertBodyView = [[UIView alloc] init];
        [self addSubview: _alertBodyView];
        _alertBodyView.backgroundColor = [UIColor whiteColor];
//        ViewRadius(_alertBodyView, 10);
    }
    return _alertBodyView;
}

- (UIImageView *)topIconImageView{
    if(!_topIconImageView){
        _topIconImageView = [[UIImageView alloc] init];
        [self.alertBodyView addSubview: _topIconImageView];
        //60x60
        _topIconImageView.image = [UIImage imageNamed:@"car_friend_reward_head_icon"];
    }
    return _topIconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.alertBodyView addSubview: _titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"多少都是爱,么么哒...";
    }
    return _titleLabel;
}

- (UIView *)moneyInputBgView{
    if (!_moneyInputBgView) {
        _moneyInputBgView = [[UIView alloc] init];
        [self.alertBodyView addSubview: _moneyInputBgView];
        _moneyInputBgView.backgroundColor = RGB(245, 245, 245);
        ViewRadius(_moneyInputBgView, 5);
    }
    return _moneyInputBgView;
}

- (UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        [self.moneyInputBgView addSubview: _unitLabel];
        _unitLabel.font = [UIFont systemFontOfSize:15];
        _unitLabel.textColor = RGB(51, 51, 51);
        _unitLabel.textAlignment = NSTextAlignmentCenter;
        _unitLabel.text = @"¥";
        [_unitLabel sizeToFit];
    }
    return _unitLabel;
}


- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        [self.moneyInputBgView addSubview: _inputTextField];
        _inputTextField.font = [UIFont systemFontOfSize:15];
        _inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.textColor = RGB(51, 51, 51);
        _inputTextField.placeholder = @"请输入打赏金额";
        _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_inputTextField.placeholder attributes:@{NSForegroundColorAttributeName : RGB(51, 51, 51)}];
//        [_inputTextField setValue: RGB(51, 51, 51) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _inputTextField;
}

- (UIView *)messageInputBgView{
    if (!_messageInputBgView) {
        _messageInputBgView = [[UIView alloc] init];
        [self.alertBodyView addSubview: _messageInputBgView];
        _messageInputBgView.backgroundColor = RGB(245, 245, 245);
        ViewRadius(_messageInputBgView, 5);
    }
    return _messageInputBgView;
}

- (UITextField *)messageTextView{
    if (!_messageTextView) {
        _messageTextView = [[UITextField alloc] init];
        _messageTextView.textAlignment = NSTextAlignmentCenter;
        _messageTextView.placeholder = @"我想捎句话...";
//        _messageTextView.placeholderTextColor = RGB(204, 204, 204);
//        _messageTextView.placeholderFont = [UIFont systemFontOfSize:15];
        _messageTextView.font = [UIFont systemFontOfSize:15];
        [self.messageInputBgView addSubview: _messageTextView];
    }
    return _messageTextView;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.font = [UIFont systemFontOfSize:12];
        _balanceLabel.textColor = RGB(255, 120, 0);
        _balanceLabel.text = @"余额:¥3.55";
        [self.alertBodyView addSubview: _balanceLabel];
    }
    return _balanceLabel;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton setTitle:@"好，赏了" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = RGB(255, 120, 0);
//        [_confirmButton setBackgroundColor: forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_confirmButton, 22.5);
        [self.alertBodyView addSubview: _confirmButton];

    }
    return _confirmButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"下次再说" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertBodyView addSubview: _cancelButton];

    }
    return _cancelButton;
}

@end
