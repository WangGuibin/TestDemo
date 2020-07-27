#import "MBProgressHUD+WM.h"

#define kHUDDismissDelay 1.5

@implementation MBProgressHUD (WM)

#pragma mark 显示信息
+ (void)show:(NSString *)text
        icon:(NSString *)icon
        view:(UIView *_Nullable)view
  afterDelay:(NSTimeInterval)afterDelay
{
    if ([text isKindOfClass:[NSError class]]) {
        text = [(NSError *)text localizedDescription];
    }
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay: afterDelay];
}


+ (void)showError:(NSString *)error
           toView:(UIView *_Nullable)view
       afterDelay:(NSTimeInterval)afterDelay{
    [self show:error icon:@"ic_mb_hud_error" view:view afterDelay:afterDelay];
}

+ (void)showError:(NSString *)error
           toView:(UIView *_Nullable)view{
    [self show:error icon:@"ic_mb_hud_error" view:view afterDelay:kHUDDismissDelay];
    
}

+ (void)showSuccess:(NSString *)success
             toView:(UIView *_Nullable)view
         afterDelay:(NSTimeInterval)afterDelay{
    [self show:success icon:@"ic_mb_hud_success" view:view afterDelay:afterDelay];
}

+ (void)showSuccess:(NSString *)success
             toView:(UIView *_Nullable)view{
    [self show:success icon:@"ic_mb_hud_success" view:view afterDelay:kHUDDismissDelay];

}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil afterDelay:kHUDDismissDelay];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil afterDelay:kHUDDismissDelay];
}

+ (void)showSuccess:(NSString *)success afterDelay:(NSTimeInterval)afterDelay
{
    [self showSuccess:success toView:nil afterDelay:afterDelay];
}

+ (void)showError:(NSString *)error afterDelay:(NSTimeInterval)afterDelay
{
    [self showError:error toView:nil afterDelay:afterDelay];
}


/// 文字 + 菊花 
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *_Nullable)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [hud.bezelView addSubview:activityView];
    [activityView startAnimating];
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}



+ (MBProgressHUD *)showText:(NSString *)text {
    return [MBProgressHUD showText:text afterDelay:kHUDDismissDelay];
}

+ (MBProgressHUD *)showText:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    [hud hideAnimated:YES afterDelay:afterDelay];
    
    return hud;
}


@end
