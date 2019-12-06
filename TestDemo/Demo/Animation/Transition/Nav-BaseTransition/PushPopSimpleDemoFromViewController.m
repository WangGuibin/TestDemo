//
// PushPopSimpleDemoFromViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/6
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
    

#import "PushPopSimpleDemoFromViewController.h"
#import "PushPopSimpleDemoToViewController.h"
#import "WGBPushPopSimpleTransition.h"

@interface PushPopSimpleDemoFromViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) WGBPushPopSimpleTransition *pushPopAnimator;

@end

@implementation PushPopSimpleDemoFromViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"转场去" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(100, 200, 200 , 30);
    [button addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)gotoNextVC{
    self.navigationController.delegate = self;
    PushPopSimpleDemoToViewController *toVC = [PushPopSimpleDemoToViewController new];
    [self.navigationController pushViewController:toVC animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushPopAnimator;
        
    }else if (operation == UINavigationControllerOperationPop){
        return self.pushPopAnimator;
    }
    return nil;
}


- (WGBPushPopSimpleTransition *)pushPopAnimator {
    if (!_pushPopAnimator) {
        _pushPopAnimator = [[WGBPushPopSimpleTransition alloc] init];
    }
    return _pushPopAnimator;
}

@end
