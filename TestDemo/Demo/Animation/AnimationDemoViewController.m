//
// AnimationDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/18
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
    

#import "AnimationDemoViewController.h"
#import "GlowingAnimationDemoViewController.h"
#import "BoomBoomBoomAnimationDemoViewController.h"
#import "WGBSpringAnimationDemoViewController.h"
#import "WGBLikeAnimationDemoViewController.h"
#import "WGBTransitionDemoListViewController.h" 
#import "WGBDrawTextDemoViewController.h"
#import "WGBEmitterDemoViewController.h"

@interface AnimationDemoViewController ()

@end

@implementation AnimationDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBTransitionDemoListViewController class],
        [GlowingAnimationDemoViewController class],
        [BoomBoomBoomAnimationDemoViewController class],
        [WGBSpringAnimationDemoViewController class],
        [WGBLikeAnimationDemoViewController class],
        [WGBDrawTextDemoViewController class],
        [WGBEmitterDemoViewController class]
     ];
}


- (NSArray *)demoTitleArray{
    return @[
        @"转场动画",
        @"发光放大缩小动画",
        @"炸裂动画",
        @"Spring弹性动画",
        @"点赞动画",
        @"绘制文字动画",
        @"粒子动画效果"
    ];
}

//UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIView.AnimationOptions.curveEaseInOut, animations: ({
//    // do stuff
//}), completion: nil)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
