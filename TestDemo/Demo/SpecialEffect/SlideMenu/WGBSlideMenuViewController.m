//
// WGBSlideMenuViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/11
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
    

#import "WGBSlideMenuViewController.h"

@interface WGBSlideMenuViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIViewController       * viewController;
@property (nonatomic,strong) UIViewController       * sidebarViewController;

@property (nonatomic,strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic,strong) UIView                 * maskView;
@property (nonatomic,strong) UIButton               * backButton;

@property (nonatomic,assign) NSInteger              swipeDistance;
@property (nonatomic,assign) NSInteger              touchDistance;

@end

@implementation WGBSlideMenuViewController

+ (instancetype)controllerWithViewController:(UIViewController *)viewController sidebarViewController:(UIViewController *)sidebarViewController {
    
    WGBSlideMenuViewController * combineViewController = [WGBSlideMenuViewController new];
    combineViewController.viewController        = viewController;
    combineViewController.sidebarViewController = sidebarViewController;
    return combineViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViewControllers];
    [self setupSubViewControllersStatus];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat viewControllerX = 0;
    CGFloat viewControllerY = 0;
    CGFloat viewControllerW = self.view.width;
    CGFloat viewControllerH = self.view.height;
    self.viewController.view.frame = CGRectMake(viewControllerX, viewControllerY, viewControllerW, viewControllerH);
    
    CGFloat sidebarViewControllerX = self.swipeDistance;
    CGFloat sidebarViewControllerY = viewControllerY;
    CGFloat sidebarViewControllerW = viewControllerW - sidebarViewControllerX;
    CGFloat sidebarViewControllerH = viewControllerH;
    self.sidebarViewController.view.frame = CGRectMake(sidebarViewControllerX, sidebarViewControllerY, sidebarViewControllerW, sidebarViewControllerH);
    
    CGFloat maskViewX = 0;
    CGFloat maskViewY = sidebarViewControllerY;
    CGFloat maskViewW = sidebarViewControllerW;
    CGFloat maskViewH = sidebarViewControllerH;
    self.maskView.frame = CGRectMake(maskViewX, maskViewY, maskViewW, maskViewH);
    
    CGFloat backButtonY = 0;
    CGFloat backButtonW = sidebarViewControllerX;
    CGFloat backButtonX = viewControllerW - backButtonW;
    CGFloat backButtonH = viewControllerH;
    self.backButton.frame = CGRectMake(backButtonX, backButtonY, backButtonW, backButtonH);
}

- (void)setupSubViewControllers {
    
    [self.view addSubview:self.sidebarViewController.view];
    [self addChildViewController:self.sidebarViewController];
    [self.view addSubview:self.viewController.view];
    [self addChildViewController:self.viewController];
}

- (void)setupSubViewControllersStatus {
    
    [self.viewController.view addGestureRecognizer:self.panGesture];
    [self.viewController.view addSubview:self.backButton];
    [self.sidebarViewController.view addSubview:self.maskView];
}

- (UIPanGestureRecognizer *)panGesture {
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (NSInteger)swipeDistance {
    
    if (_swipeDistance == 0) {
        _swipeDistance = 60.0f;
    }
    return _swipeDistance;
}

- (NSInteger)touchDistance {
    
    if (_touchDistance == 0) {
        _touchDistance = 60.0f;
    }
    return _touchDistance;
}

- (UIView *)maskView {
    
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return _maskView;
}

- (UIButton *)backButton {
    
    if (!_backButton) {
        _backButton = [UIButton new];
        _backButton.backgroundColor = [UIColor clearColor];
        _backButton.hidden = YES;
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    
    if (panGesture.view.x > 0) {
        CGRect frame = panGesture.view.frame;
        frame.origin.x = 0;
        panGesture.view.frame = frame;
    }
    
    CGFloat x      = self.view.width * 0.5f - (self.view.width - self.swipeDistance);
    CGFloat offset = (-panGesture.view.frame.origin.x / (self.view.width - self.swipeDistance));
    CGPoint point  = [panGesture translationInView:self.viewController.view];
    [self.maskView setAlpha:0.7f - 0.7f * offset];
    
    [UIView animateWithDuration:0.25f animations:^{
        CGPoint center = self.viewController.view.center;
        center.x += point.x;
        if (center.x <= x) center.x = x;
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            if (center.x < (self.view.width - self.swipeDistance) * 0.5f) {
                center.x = x;
                self.maskView.alpha    = 0.0f;
                self.backButton.hidden = NO;
            } else {
                center.x = self.view.width * 0.5f;
                self.maskView.alpha    = 0.7f;
                self.backButton.hidden = YES;
            }
        }
        self.viewController.view.center = center;
    }];
    [panGesture setTranslation:CGPointZero inView:self.viewController.view];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self.viewController.view];
    if (point.x > 0 && point.x < self.view.width - self.touchDistance) {
        return NO;
    }
    return YES;
}

- (void)backButtonClick:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25f animations:^{
        CGPoint center = self.viewController.view.center;
        center.x = self.view.center.x;
        self.viewController.view.center = center;
        self.backButton.hidden          = YES;
        self.maskView.alpha             = 0.7f;
    }];
}

@end
