//
// WGBStrokeEndDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/23
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
    

#import "WGBStrokeEndDemoViewController.h"

@interface WGBStrokeEndDemoViewController ()

@property (nonatomic, strong) UIView *demoView;


@end

@implementation WGBStrokeEndDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.demoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.centerX.mas_equalTo(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
        
    [self startAnimationWithPath:[self pentagrammePath]];
    [self startAnimationWithPath:[self circlePath]];

//    [self startAnimationWithPath:[self drawTrianglePath]];
//    [self startAnimationWithPath:[self drawSecondBezierPath]];
//    [self startAnimationWithPath:[self drawThirdBezierPath]];

}


- (void)startAnimationWithPath:(UIBezierPath *)path{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.demoView.bounds;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    [self.demoView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 3.0f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    [shapeLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];

}

- (UIView *)demoView {
    if (!_demoView) {
        _demoView = [[UIView alloc] initWithFrame:CGRectZero];
        _demoView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_demoView];
    }
    return _demoView;
}



// 画三角形
- (UIBezierPath *)drawTrianglePath {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(20, 20)];
  [path addLineToPoint:CGPointMake(self.demoView.width - 40, 20)];
  [path addLineToPoint:CGPointMake(self.demoView.width / 2, self.demoView.height - 20)];
    [path closePath];
    return path;
}


- (UIBezierPath *)drawSecondBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 首先设置一个起始点
    [path moveToPoint:CGPointMake(20, self.demoView.size.height - 100)];
    
    // 添加二次曲线
    [path addQuadCurveToPoint:CGPointMake(self.demoView.size.width - 20, self.demoView.size.height - 100)
                 controlPoint:CGPointMake(self.demoView.size.width / 2, 0)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 5.0;
    return path;
}

- (UIBezierPath *)drawThirdBezierPath {
  UIBezierPath *path = [UIBezierPath bezierPath];
  // 设置起始端点
  [path moveToPoint:CGPointMake(20, 150)];
  
  [path addCurveToPoint:CGPointMake(300, 150)
          controlPoint1:CGPointMake(160, 0)
          controlPoint2:CGPointMake(160, 250)];
  
  path.lineCapStyle = kCGLineCapRound;
  path.lineJoinStyle = kCGLineJoinRound;
  path.lineWidth = 5.0;
    return path;
}

//五角星路径
- (UIBezierPath *)pentagrammePath
{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.demoView.width/2, 0)];
    [path addLineToPoint:CGPointMake(self.demoView.width*13/16, self.demoView.height*19/20)];
    [path addLineToPoint:CGPointMake(0, self.demoView.height*29/80)];
    [path addLineToPoint:CGPointMake(self.demoView.width, self.demoView.height*29/80)];
    [path addLineToPoint:CGPointMake(self.demoView.width*3/16, self.demoView.height*19/20)];
    [path closePath];
    return path;
}

//圆环路径
- (UIBezierPath *)circlePath
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.demoView.width/2.0, self.demoView.height/2.0) radius:self.demoView.width/2.0 - 5 startAngle:- M_PI_2 endAngle:- M_PI_2 + 2 * M_PI clockwise:YES];
    return path;
}

@end
