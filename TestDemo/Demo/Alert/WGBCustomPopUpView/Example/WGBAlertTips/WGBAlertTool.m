//
//  WGBAlertTool.m
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import "WGBAlertTool.h"
#import "WGBCommonLeftRightButtonAlertView.h"
#import "HPEditSignatureAlertView.h"
#import "HPSelectSexAlertView.h"
#import "HPCommonCancelConfirmAlertView.h"
#import "HPPublishAlertView.h"

@implementation WGBAlertTool
/// 免费次数已用完的弹窗
+ (void)showFreeTimesExpiredAlertWithCallBack:(void(^)(NSInteger index))callBack{
    
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
    WGBCommonLeftRightButtonAlertView *alertView = [WGBCommonLeftRightButtonAlertView shareGuideVIPAlertView];
    CGFloat alertHeight = 170;
    CGFloat alertW =  KWIDTH - 80;
    if (KWIDTH <= 320) {
        alertW = 300;
    }
    alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
    alertView.layer.cornerRadius = 15;
    alertView.layer.masksToBounds = YES;
    
    alertView.alertTitleLabel.text = @"免费次数已用完";
    NSString *originStr = @"每邀请1人，可享受1天VIP！\n可无限叠加哦！";
    NSString *firstSubStr = @"1人";
    NSString *secondSubStr = @"1天VIP";
    NSRange firstRange = [originStr rangeOfString:firstSubStr];
    NSRange secondRange = [originStr rangeOfString:secondSubStr];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:originStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#007BFA"] range:firstRange];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFAD2E"] range:secondRange];
    alertView.messageLabel.attributedText = attributeStr;
    
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [bgView addSubview: alertView];
    alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    pop.contentView = bgView;
    pop.animationType = WGBAlertAnimationTypeCenter;
    [pop show];
    [alertView setCancelBlock:^{
        [pop dismiss];
    }];
    
    [alertView setClickButtonActionBlock:^(NSInteger index) {
        !callBack? : callBack(index);
        [pop dismiss];
    }];
}

+ (void)showCommitConfirmCheckReviewTips:(NSString * _Nullable)tips callBack:(void(^ _Nullable)(NSInteger index))callBack {
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
    WGBCommonLeftRightButtonAlertView *alertView = [WGBCommonLeftRightButtonAlertView shareCommitReviewAlertView];
    if (tips.length) {
        alertView.messageLabel.text = tips;
    }
    
    CGFloat alertHeight = 170;
    CGFloat alertW =  KWIDTH - 80;
    if (KWIDTH <= 320) {
        alertW = 300;
    }
    alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
    alertView.layer.cornerRadius = 15;
    alertView.layer.masksToBounds = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [bgView addSubview: alertView];
    alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    pop.contentView = bgView;
    pop.animationType = WGBAlertAnimationTypeCenter;
    [pop show];
    [alertView setCancelBlock:^{
        [pop dismiss];
    }];
    
    [alertView setClickButtonActionBlock:^(NSInteger index) {
        !callBack? : callBack(index);
        [pop dismiss];
    }];
}


///MARK:- 简单封装系统弹窗Alert/ActionSheet 取消下标为0 其他从上往下(从左往右)的顺序开始排列下标1起步
+ (void)showSystemStyleAlertSheetWithTitle:(NSString *)alertTitle
                              alertMessage:(NSString *)alertMessage
                               cancelTitle:(NSString *)cancelTitle
                           otherItemsTitle:(NSArray *)otherItemsTitle
                            preferredStyle:(UIAlertControllerStyle)preferredStyle
                                   handler:(void(^)(NSInteger index))callBack {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:preferredStyle];
        //取消按钮
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (callBack) {
                callBack(0);
            }
        }];
        [cancelAction setValue:[UIColor darkTextColor] forKey:@"titleTextColor"];
        [alertC addAction:cancelAction];

    //其他选项
    if (![otherItemsTitle isKindOfClass:[NSNull class]] && otherItemsTitle != nil && otherItemsTitle.count) {
        for (int i = 0; i < otherItemsTitle.count; i++) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherItemsTitle[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (callBack) {
                    callBack(i+1);
                }
            }];
            [otherAction setValue:[UIColor darkTextColor] forKey:@"titleTextColor"];
            [alertC addAction:otherAction];
        }
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}


///MARK:- 系统自带的简单通用的左右按钮这种Alert弹窗
+ (void)showSystemStyleCommonAlertTitle:(NSString *)title
                            messageTips:(NSString *)message
                        leftButtonTitle:(NSString *)leftButtonTitle
                       rightButtonTitle:(NSString *)rightButtonTitle
                        leftButtonBlock:(dispatch_block_t)leftButtonBlock
                       rightButtonBlock:(dispatch_block_t)rightButtonBlock{
    
    [self showSystemStyleAlertSheetWithTitle:title alertMessage:message cancelTitle:leftButtonTitle otherItemsTitle:@[rightButtonTitle] preferredStyle:(UIAlertControllerStyleAlert) handler:^(NSInteger index) {
        if (index == 0) {
            !leftButtonBlock? : leftButtonBlock();
        }else{
            !rightButtonBlock? : rightButtonBlock();
        }
    }];
    
}


///MARK:- 设置性别
+ (void)showSelectSexAlertViewWithCallBack:(void(^)(NSInteger sexIndex,NSString *selectSexValue))callBack{
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
    HPSelectSexAlertView *alertView = [HPSelectSexAlertView fromXIB];
    CGFloat alertW =  KWIDTH - 80;
    CGFloat alertHeight = 240;
    if (KWIDTH < 320) {
        alertW = 300;
    }
    alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [bgView addSubview: alertView];
    alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    pop.contentView = bgView;
    pop.animationType = WGBAlertAnimationTypeAlert;
    [pop show];
    
    [alertView setCancelBlock:^{
        [pop dismiss];
    }];
    
    [alertView setSelectSexBlock:^(NSInteger index, NSString * _Nonnull selectValue) {
        !callBack? : callBack(index,selectValue);
        [pop dismiss];
    }];
}

///MARK:- 设置个性签名
+ (void)showSignatureInputAlertWithCallBack:(void(^)(NSString *signature))callBack{
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
    __block HPEditSignatureAlertView *alertView = [HPEditSignatureAlertView fromXIB];
    CGFloat alertW =  KWIDTH - 80;
    CGFloat alertHeight = 250;
    if (KWIDTH <= 320) {
        alertW = 300;
    }
    alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [bgView addSubview: alertView];
    alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    pop.contentView = bgView;
    pop.animationType = WGBAlertAnimationTypeAlert;
    //    pop.touchDismiss = YES;
    [pop show];
    
    [[kNotificationCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary * info= [x userInfo];
        CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithDuration:0.25 animations:^{
            alertView.y = KHIGHT - keyboardHeight - alertView.height - 20;
        }];
    }];
    
    [[kNotificationCenter rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [UIView animateWithDuration:0.25 animations:^{
            alertView.centerY = KHIGHT/2.0;
        }];
    }];
    
    [alertView setEditCallBackBlock:^(NSString * _Nonnull signatureText, NSInteger index) {
        if (index) {
            !callBack? : callBack(signatureText);
        }
        [pop dismiss];
    }];
}


///MARK:- 自定义两个按钮的 提示信息弹窗
+ (void)showCustomTipsAlertWithMessage:(NSString * _Nullable)message
                         fromSuperView:(UIView *_Nullable)superView
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                       leftButtonBlock:(dispatch_block_t)leftButtonBlock
                      rightButtonBlock:(dispatch_block_t)rightButtonBlock{
    
    WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
    HPCommonCancelConfirmAlertView *alertView = [HPCommonCancelConfirmAlertView fromXIB];
    CGFloat alertW =  KWIDTH - 80;
    if (KWIDTH <= 320) {
        alertW = 300;
    }
    
    CGSize textSize = [message sizeWithFont:[UIFont systemFontOfSize:14] maxW: alertW - 30];
    CGFloat alertHeight = 75 + textSize.height + 0.5;
    
    if (!message.length) {
        alertHeight = 100;
    }else{
        alertView.message = message;
    }
    
    if (leftButtonTitle.length) {
        alertView.leftButtonTitle = leftButtonTitle;
    }
    
    if (rightButtonTitle.length) {
        alertView.rightButtonTitle = rightButtonTitle;
    }
    
    alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [bgView addSubview: alertView];
    alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    pop.contentView = bgView;
    pop.animationType = WGBAlertAnimationTypeAlert;
    pop.touchDismiss = YES;
    
    if (superView) {
        [pop showFromSuperView:superView];
    }else{
        [pop show];
    }
    
    [alertView setClickButtonActionBlock:^(NSInteger index) {
        if (index == 0) {
            !leftButtonBlock? : leftButtonBlock();
        }else{
            !rightButtonBlock? : rightButtonBlock();
        }
        [pop dismiss];
    }];
}


///MARK:- 精选页面的弹窗
+ (void)showFeaturedLevelLimitAlertWithLeftBlock:(dispatch_block_t)leftBlock
                                      rightBlock:(dispatch_block_t)rightBlock{
    [self showCustomTipsAlertWithMessage:@"此功能只对LV.4以上用户开放！" fromSuperView: nil leftButtonTitle:@"" rightButtonTitle:@"确定" leftButtonBlock:^{
        !leftBlock? : leftBlock();
    } rightButtonBlock:^{
        !rightBlock? : rightBlock();
    }];
}


///MARK:- 发布动态页面选择入口弹窗
+ (void)showPostSelectMediaAlertViewWithCallBack:(void(^)(NSInteger index))callBack{
        WGBCustomPopUpView *pop = [[WGBCustomPopUpView alloc] initWithFrame:CGRectZero];
        HPPublishAlertView *alertView = [HPPublishAlertView fromXIBWithIndex: 0];
        alertView.layer.cornerRadius = 15;
        alertView.layer.masksToBounds = YES;
        CGFloat alertW =  KWIDTH - 80;
        if (KWIDTH <= 320) {
            alertW = 300;
        }
        CGFloat alertHeight = 225;
        alertView.frame = CGRectMake(0, 0, alertW , alertHeight);
        UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        [bgView addSubview: alertView];
        alertView.center = CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
        pop.contentView = bgView;
        pop.animationType = WGBAlertAnimationTypeCenter;
        [pop show];
        [alertView setCancelBlock:^{
            [pop dismiss];
        }];
    
        [alertView setSelectPublishMediaBlock:^(NSInteger index) {
            !callBack? : callBack(index);
            [pop dismiss];
        }];

}



@end




