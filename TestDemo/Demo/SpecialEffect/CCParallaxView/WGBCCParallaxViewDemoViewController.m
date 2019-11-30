//
// WGBCCParallaxViewDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/30
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
    

#import "WGBCCParallaxViewDemoViewController.h"
#import "CCParallaxView.h"

@interface WGBCCParallaxViewDemoViewController ()
@property (weak, nonatomic) IBOutlet CCParallaxView *parallaxView;

@end

@implementation WGBCCParallaxViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2000, 1200)];
    UIImageView *imgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky.jpg"]];
    [viewTemp addSubview: imgView];
    [self.parallaxView addPalallaxElement:viewTemp];

    
    viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1300, 1000)];
    imgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird1.png"]];
    [viewTemp addSubview: imgView];
    imgView.center = CGPointMake(600, 500);
    [self.parallaxView addPalallaxElement:viewTemp];
    
    
    viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1100, 900)];
    imgView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird2.png"]];
    [viewTemp addSubview: imgView];
    imgView.center = CGPointMake(800, 200);
    [self.parallaxView addPalallaxElement:viewTemp];

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
