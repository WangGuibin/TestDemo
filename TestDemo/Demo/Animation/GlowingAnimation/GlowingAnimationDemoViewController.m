//
//  GlowingAnimationDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GlowingAnimationDemoViewController.h"


@interface GlowingAnimationDemoViewController ()

@property (nonatomic,strong) UIView *testView ;

@end

@implementation GlowingAnimationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    testView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview: testView];
    self.testView = testView;
    self.testView.contentScaleFactor = UIScreen.mainScreen.scale;
    self.testView.layer.masksToBounds = NO;
    
    [self addShadow];
    [self setupAnimation];
    [self setupScaleAnimation];
}


- (void)addShadow{
    self.testView.layer.cornerRadius = 5;
    self.testView.layer.shadowPath  = [UIBezierPath bezierPathWithRoundedRect:self.testView.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(5, 5)].CGPath;
    self.testView.layer.shadowColor = [UIColor redColor].CGColor;
    self.testView.layer.shadowOffset = CGSizeZero;
    self.testView.layer.shadowRadius = 10;
    self.testView.layer.shadowOpacity = 1;

}

- (void)setupAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    animation.fromValue = @(10);
    animation.toValue = @(0);
    animation.autoreverses = YES;
    animation.additive = NO;
    animation.duration = 1.5;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    [self.testView.layer addAnimation: animation forKey:@"glowingAnimation"];
}

- (void)setupScaleAnimation{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    demoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: demoView];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.0f;
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(1.3);
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [demoView.layer addAnimation:scaleAnimation forKey:@"scaleAnimationDemo"];
}


@end
