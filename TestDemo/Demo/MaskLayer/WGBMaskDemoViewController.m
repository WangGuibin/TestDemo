//
//  WGBMaskDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBMaskDemoViewController.h"
#import "UIImage+MaskExtension.h"

@interface WGBMaskDemoViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *testImageView ;
@property (nonatomic, strong) UIView *testView;

@end

@implementation WGBMaskDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100 , 100)];
    self.testImageView.image = [UIImage imageNamed:@"car_friend_reward_head_icon"];
    [self.view addSubview: self.testImageView];
    
    @weakify(self);
    [self.bgImageView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable gestureRecoginzer) {
        @strongify(self);
        [self.bgImageView removeFromSuperview];
        [self.testView removeFromSuperview];
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [[UIApplication sharedApplication].delegate.window addSubview: self.bgImageView];
    [[UIApplication sharedApplication].delegate.window addSubview: self.testView];

    CGRect rect = [self.testImageView convertRect:CGRectMake(0, 0, 100 , 600) toView:[UIApplication sharedApplication].delegate.window];
    
   self.testView.frame = CGRectMake(rect.origin.x, rect.origin.y+100, 100 , 500);
    CAShapeLayer *testLayer = [CAShapeLayer layer];
    UIBezierPath *testPath = [UIBezierPath bezierPathWithRoundedRect:self.testView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(50, 50)];
    testLayer.path = testPath.CGPath;
    self.testView.layer.mask = testLayer;
//   ViewRadius(self.testView, 50);
    BOOL isPath = arc4random()%2;
    if (isPath) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(50, 50)];
        self.bgImageView.image = [UIImage createMaskImageWithRectBounds:[UIScreen mainScreen].bounds shapePath:path maskBackgroundColor: [[UIColor blackColor] colorWithAlphaComponent:0.45]];
    }else{
        self.bgImageView.image = [UIImage imageWithTipRect:rect tipRectRadius:50 bgColor:RGBA(0, 0, 0, 0.45)];
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}


- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] init];
        _testView.backgroundColor = RGB(205,58,47);
    }
    return _testView;
}

@end
