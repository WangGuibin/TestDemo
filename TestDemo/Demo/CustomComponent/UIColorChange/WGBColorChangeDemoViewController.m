//
// WGBColorChangeDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/16
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
    

#import "WGBColorChangeDemoViewController.h"
#import "WGBLoadingView.h"

@interface WGBColorChangeDemoViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *cubeView;
@property (nonatomic,strong) WGBLoadingView *loadingView ;

@end

@implementation WGBColorChangeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    WGBLoadingView *loadingView = [[WGBLoadingView alloc] initWithFrame:CGRectMake(150, 300, 100 , 100)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    
}


- (IBAction)changeColorProgress:(UISlider *)sender {
    UIColor *fromColor = [UIColor orangeColor];
    UIColor *toColor = [UIColor blueColor];
    UIColor *bgColor = [self transformFromColor:fromColor toColor:toColor progress:sender.value];
    self.cubeView.backgroundColor = bgColor;
    self.loadingView.loadingLayer.backgroundColor = bgColor.CGColor;
}

//颜色过渡算法参考于 https://blog.csdn.net/u013282507/article/details/72518030
- (UIColor *)transformFromColor:(UIColor*)fromColor
                        toColor:(UIColor *)toColor
                       progress:(CGFloat)progress {

    progress = progress >= 1 ? 1 : progress;
    progress = progress <= 0 ? 0 : progress;

    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);

    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);

    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }

    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }

    CGFloat r = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat g = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat b = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;

    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
