//
//  WGBCustomPopUpView.m
//  WGBCustomAlertView
//
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




#import "WGBCustomPopUpView.h"

@implementation UIView (WGBAlertExtra)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}
@end


@interface WGBCustomPopUpView ()

@end

@implementation WGBCustomPopUpView

- (instancetype)init{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.coverMaskAlpha = 0.45;
        self.animationDuration = 0.25;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.coverMaskAlpha];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds; //不管你外面怎么设置 我都是全屏的 (常规操作)
    self = [super initWithFrame:frame];
    if (self) {
        /// 初始化配置
        self.coverMaskAlpha = 0.45;
        self.animationDuration = 0.25;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.coverMaskAlpha];
    }
    return self;
}


/// 添加内容视图
- (void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    [self addSubview: contentView];
}

    /// 设置动画弹出的类型 初始化内容视图的frame 根据不同类型作动画处理
- (void)setAnimationType:(WGBAlertAnimationType)animationType{
    _animationType = animationType;
    [self initContentViewFrameWithAnimationType: animationType];
}

- (void)setAnimationDuration:(CGFloat)animationDuration{
    _animationDuration = animationDuration;
}

- (void)setTouchDismiss:(BOOL)touchDismiss{
    _touchDismiss = touchDismiss;
    if (touchDismiss) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [ [UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(touchDismissAction)];
        [self addGestureRecognizer: tap];
    }
}

- (void)touchDismissAction{
    [self dismiss];
}

    ///MARK:- 初始化内容视图的位置
- (void)initContentViewFrameWithAnimationType:(WGBAlertAnimationType )animationType{
    CGPoint center =  CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    self.contentView.center = center;
    CGFloat viewX  = self.contentView.x;
    CGFloat viewY  = self.contentView.y;
    CGFloat viewW  = self.contentView.width;
    CGFloat viewH = self.contentView.height;

    switch (animationType) {
        case WGBAlertAnimationTypeCenter:{
            self.contentView.center = center;
        }
            break;
        case WGBAlertAnimationTypeUp:{
                // 初始化在屏幕上方看不见🙈的位置
            viewY  = - viewH;
            self.contentView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        }
            break;
        case WGBAlertAnimationTypeBottom:{
                // 初始化在屏幕下方看不见🙈的位置
            viewY  =  KHIGHT ;
            self.contentView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        }
            break;
        case WGBAlertAnimationTypeLeft:{
                // 初始化在屏幕左方看不见🙈的位置
            viewX  =  -viewW ;
            self.contentView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        }
            break;
        case WGBAlertAnimationTypeRight:{
                // 初始化在屏幕右方看不见🙈的位置
            viewX  =  KWIDTH  ;
            self.contentView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        }
            break;
            case WGBAlertAnimationTypeAlert:{
                viewY = KHIGHT;
                self.contentView.frame = CGRectMake(viewX, viewY, viewW , viewH);
            }
            break;
        default:{
            self.contentView.center = center;
        }
            break;
    }
}

    ///MARK:- 从中心弹出的动画
- (void)showAlertCenterScaleAnimation{
    self.contentView.transform = CGAffineTransformIdentity;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = self.animationDuration;
    animation.removedOnCompletion =YES;
    animation.fillMode = kCAFillModeForwards;
    [self.contentView.layer addAnimation: animation forKey:nil];
}
    ///MARK:- 从中心弹出的动画
- (void)dismissAlertCenterScaleAnimation{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    [self showFromSuperView:nil];
}

- (void)showFromSuperView:(UIView *)superView{
    if (!superView) {
        superView = [[UIApplication sharedApplication] keyWindow];
    }
    
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[WGBCustomPopUpView class]]) {
            ///FIXME:- 2019/09/26 09:31 防止点击过快(光速QA/单身30年的手速)同一个弹窗重复弹出的现象
            return;
        }
    }

    [self showBackgroundFromSuperView: superView]; // 蒙版
    
__block    CGPoint center =  CGPointMake(KWIDTH/2.0, KHIGHT/2.0);
    switch (self.animationType) {
        case WGBAlertAnimationTypeCenter:{
            [self showAlertCenterScaleAnimation];
        }
            break;
        case WGBAlertAnimationTypeUp:{
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.contentView.center = center;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case WGBAlertAnimationTypeBottom:{
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.contentView.center = center;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case WGBAlertAnimationTypeLeft:{
            [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                self.contentView.center = center;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case WGBAlertAnimationTypeRight:{
            [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                self.contentView.center = center;
            } completion:^(BOOL finished) {
            }];
        }
            break;
            case WGBAlertAnimationTypeAlert:{
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                window.userInteractionEnabled = NO;
                self.contentView.alpha = 0;
                self.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                [UIView animateWithDuration:self.animationDuration animations:^{
                    self.contentView.center = center;
                    self.contentView.alpha = 1.0;
                    self.contentView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    window.userInteractionEnabled = YES;
                }];
            }
            break;
        default:{
            [self showAlertCenterScaleAnimation];
        }
            break;
    }
}

- (void)dismiss{
    /// 动画原则是操作contentView的frame
    __block    CGFloat viewW  = self.contentView.width;
    __block    CGFloat viewH = self.contentView.height;
    switch (self.animationType) {
        case WGBAlertAnimationTypeCenter:{
            [self dismissAlertCenterScaleAnimation];
        }
            break;
        case WGBAlertAnimationTypeUp:{
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.contentView.y = -viewH;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case WGBAlertAnimationTypeBottom:{
            [UIView animateWithDuration:self.animationDuration animations:^{
                self.contentView.y = KHIGHT;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case WGBAlertAnimationTypeLeft:{
            [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                self.contentView.x =  -viewW;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
        case WGBAlertAnimationTypeRight:{
            [UIView animateWithDuration:self.animationDuration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                self.contentView.x = KWIDTH;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
            break;
            case WGBAlertAnimationTypeAlert:{
                UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                window.userInteractionEnabled = NO;
                [UIView animateWithDuration:self.animationDuration animations:^{
                    CGRect frame = self.contentView.frame;
                    frame.origin.y += KHIGHT;
                    self.contentView.frame = frame;
                    self.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    self.contentView.alpha = 0 ;
                    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0];
                } completion:^(BOOL finished) {
                    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                    window.userInteractionEnabled = YES;
                    [self removeFromSuperview];
                }];
            }
            break;
        default:{
            [self dismissAlertCenterScaleAnimation];
        }
            break;
    }
}

/// 加蒙版视图动画
- (void)showBackgroundFromSuperView:(UIView *)superView{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.coverMaskAlpha];
    [superView addSubview: self];
}

@end


@interface WGBAlertViewController()
/*!
 @property
 @abstract 展示内容控制器
 */
@property (nonatomic,strong,readwrite) UIViewController *contentViewController;

@end

@implementation WGBAlertViewController

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController{
    self = [super init];
    if (self) {
        self.contentViewController = contentViewController;
    }
    return self;
}

- (void)setContentViewController:(UIViewController *)contentViewController{
    _contentViewController = contentViewController;
    _contentViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)setIsMask:(BOOL)isMask{
    _isMask = isMask;
    if (_isMask) {
        self.contentViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    }
}

- (void)show{
    [self isMask];
    [[self topViewController] presentViewController: self.contentViewController animated:YES completion:^{
        
    }];
}

- (void)dismiss{
    [self.contentViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

@end

