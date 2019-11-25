//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;



/**
 仿安卓系统 Toast 显示文本消息，会自动消失

 @param text 需要显示的文本消息
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showText:(NSString *)text;

/**
 仿安卓系统 Toast 显示文本消息

 @param text 需要显示的文本消息
 @param afterDelay 需要在几秒后自动消失
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showText:(NSString *)text afterDelay:(NSTimeInterval)afterDelay;

@end
