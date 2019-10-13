//
//  WGBAlertTool.h
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface WGBAlertTool : NSObject
/// 免费次数已用完的弹窗
+ (void)showFreeTimesExpiredAlertWithCallBack:(void(^)(NSInteger index))callBack;

/**
 MRAK:-  简单提示弹窗

 @param tips 提示文字，提示消息
 @param callBack 回调
 */
+ (void)showCommitConfirmCheckReviewTips:(NSString * _Nullable)tips callBack:(void(^ _Nullable)(NSInteger index))callBack;

///MARK:- 简单封装系统弹窗Alert/ActionSheet 取消下标为0 其他从上往下(从左往右)的顺序开始排列下标1起步
+ (void)showSystemStyleAlertSheetWithTitle:(NSString *)alertTitle
                              alertMessage:(NSString *)alertMessage
                               cancelTitle:(NSString *)cancelTitle
                           otherItemsTitle:(NSArray *)otherItemsTitle
                            preferredStyle:(UIAlertControllerStyle)preferredStyle
                                   handler:(void(^)(NSInteger index))callBack;

///MARK:- 系统自带的简单通用的左右按钮这种Alert弹窗
+ (void)showSystemStyleCommonAlertTitle:(NSString *)title
                            messageTips:(NSString *)message
                        leftButtonTitle:(NSString *)leftButtonTitle
                       rightButtonTitle:(NSString *)rightButtonTitle
                        leftButtonBlock:(dispatch_block_t)leftButtonBlock
                       rightButtonBlock:(dispatch_block_t)rightButtonBlock;


///MARK:- 设置性别
+ (void)showSelectSexAlertViewWithCallBack:(void(^)(NSInteger sexIndex,NSString *selectSexValue))callBack;
///MARK:- 设置个性签名
+ (void)showSignatureInputAlertWithCallBack:(void(^)(NSString *signature))callBack;

///MARK:- 自定义两个按钮的 提示信息弹窗
+ (void)showCustomTipsAlertWithMessage:(NSString * _Nullable)message
                         fromSuperView:(UIView *_Nullable)superView
                       leftButtonTitle:(NSString *)leftButtonTitle
                      rightButtonTitle:(NSString *)rightButtonTitle
                       leftButtonBlock:(dispatch_block_t)leftButtonBlock
                      rightButtonBlock:(dispatch_block_t)rightButtonBlock;
///MARK:- 精选页面的弹窗
+ (void)showFeaturedLevelLimitAlertWithLeftBlock:(dispatch_block_t)leftBlock
                                      rightBlock:(dispatch_block_t)rightBlock;

@end

NS_ASSUME_NONNULL_END
