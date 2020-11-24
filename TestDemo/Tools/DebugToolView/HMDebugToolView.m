////
#ifdef DEBUG

#import "HMDebugToolView.h"
#import "YYFPSLabel.h"
#import <FLEX/FLEX.h>
#import "PAirSandbox.h"

@interface HMDebugToolView ()<UIContextMenuInteractionDelegate>

@property (nonatomic, strong) UIView *bgView;

@end

@implementation HMDebugToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [self.bgView addInteraction:interaction];
        self.bgView.frame = self.bounds;

        YYFPSLabel *fps = [[YYFPSLabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:fps];
        [self.bgView bringSubviewToFront:fps];
        
    }
    return self;
}


// MARK: - UIContextMenuInteractionDelegate
- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location
{
    // 菜单栏提供者
    UIContextMenuActionProvider actionProvider = ^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        // 创建子菜单
        UIAction *testAction =
        [UIAction actionWithTitle:@"测试环境"
                            image:[UIImage systemImageNamed:@"ladybug"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
//            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:HMHostEnvSwitchKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [UIView animateWithDuration:0.25 animations:^{
//                exit(1);
//            }];
        }];
        UIAction *productAction =
        [UIAction actionWithTitle:@"正式环境"
                            image:[UIImage systemImageNamed:@"projective"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
//            [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:HMHostEnvSwitchKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [UIView animateWithDuration:0.25 animations:^{
//                exit(1);
//            }];
        }];
                
        UIAction *h5Action =
        [UIAction actionWithTitle:@"H5任意门"
                            image:[UIImage systemImageNamed:@"chevron.left.slash.chevron.right"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
//            HMH5DebugToolViewController *vc = [HMH5DebugToolViewController new];
//            UITabBarController *tabVC = (UITabBarController *)self.viewController;
//            [(UINavigationController *)tabVC.selectedViewController pushViewController:vc animated:YES];
        }];

        UIAction *flfxAction =
        [UIAction actionWithTitle:@"FLFX页面调试"
                            image:[UIImage systemImageNamed:@"doc.text.magnifyingglass"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
            [[FLEXManager sharedManager] showExplorer];
        }];

        UIAction *sandBoxAction =
        [UIAction actionWithTitle:@"查看沙盒"
                            image:[UIImage systemImageNamed:@"shippingbox"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
            [[PAirSandbox sharedInstance] showSandboxBrowser];
        }];


        
        UIMenu *menu = [UIMenu menuWithTitle:@""
                                       image:[UIImage systemImageNamed:@"pencil.and.outline"]
                                  identifier:@"menu"
                                     options:UIMenuOptionsDisplayInline
                                    children:@[testAction,productAction,h5Action,flfxAction,sandBoxAction]];
        NSInteger env = 1;
//        [[[NSUserDefaults standardUserDefaults] objectForKey:HMHostEnvSwitchKey] integerValue];
        return [UIMenu menuWithTitle: env == 1? @"当前是测试环境" : @"当前是正式环境" children:@[menu]];
    };
    return [UIContextMenuConfiguration configurationWithIdentifier:@"menus"
                                                   previewProvider:nil
                                                    actionProvider:actionProvider];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
    }
    return _bgView;
}

@end
#endif
