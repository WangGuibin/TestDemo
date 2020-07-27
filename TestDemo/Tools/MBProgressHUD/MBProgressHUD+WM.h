#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN
//新版
@interface MBProgressHUD (WM)

/// 打对勾✅ 或者 打❌
+ (void)showSuccess:(NSString *)success
             toView:(UIView *_Nullable)view
         afterDelay:(NSTimeInterval)afterDelay;

+ (void)showError:(NSString *)error
           toView:(UIView *_Nullable)view
       afterDelay:(NSTimeInterval)afterDelay;

+ (void)showSuccess:(NSString *)success
             toView:(UIView *_Nullable)view;

+ (void)showError:(NSString *)error
           toView:(UIView *_Nullable)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (void)showSuccess:(NSString *)success
         afterDelay:(NSTimeInterval)afterDelay;
+ (void)showError:(NSString *)error
       afterDelay:(NSTimeInterval)afterDelay;


//菊花 + 文字
+ (MBProgressHUD *)showMessage:(NSString *)message
                        toView:(UIView *_Nullable)view;
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)hideHUDForView:(UIView *)view;

//默认2s Toast
+ (MBProgressHUD *)showText:(NSString *)text;
//设置延时
+ (MBProgressHUD *)showText:(NSString *)text
                 afterDelay:(NSTimeInterval)afterDelay;

@end

NS_ASSUME_NONNULL_END
