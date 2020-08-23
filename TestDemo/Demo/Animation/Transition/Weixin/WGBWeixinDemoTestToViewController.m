//
// WGBWeixinDemoTestToViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/22
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
    

#import "WGBWeixinDemoTestToViewController.h"
#import "WGBWeixinVideoTransition.h"
#import "WGBTransitionInteractive.h"

@interface WGBWeixinDemoTestToViewController ()

@property (nonatomic, strong) WGBWeixinVideoTransition *transition;
//手势过渡转场
@property (nonatomic, strong) WGBTransitionInteractive *transitionInteractive;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WGBWeixinDemoTestToViewController

///MARK:- <WGBWeixinVideoTransitionDelegate>
- (UIView *)wgb_TransitionContentView{
    return self.imageView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transition.transitionType = WGBWeiXinTransitionTypePush;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WGBCustomNavgationViewController *nvc = (WGBCustomNavgationViewController *)self.navigationController;
    nvc.popGestureEnable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    WGBCustomNavgationViewController *nvc = (WGBCustomNavgationViewController *)self.navigationController;
    nvc.popGestureEnable = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)tapClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        self.transition.transitionType = WGBWeiXinTransitionTypePush;
        return self.transition;
    }else if (operation == UINavigationControllerOperationPop){
        self.transition.transitionType = WGBWeiXinTransitionTypePop;
        return self.transition;
    }
    return self.transition;
}

//返回处理push/pop手势过渡的对象 这个代理方法依赖于上方的方法 ，这个代理实际上是根据交互百分比来控制上方的动画过程百分比
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    
    if (self.transition.transitionType == WGBWeiXinTransitionTypePop) {
        return self.transitionInteractive.isInteractive == YES ? self.transitionInteractive : nil;
    }
    return nil;
}


- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 500)];
        _imageView.center = CGPointMake(KWIDTH/2, KHIGHT/2);
        _imageView.image = [UIImage imageNamed:@"landscape"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        _imageView.userInteractionEnabled = YES;
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (WGBWeixinVideoTransition *)transition {
    if (!_transition) {
        _transition = [[WGBWeixinVideoTransition alloc] init];
    }
    return _transition;
}


- (WGBTransitionInteractive *)transitionInteractive {
    if (!_transitionInteractive) {
        _transitionInteractive = [[WGBTransitionInteractive alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}

@end
