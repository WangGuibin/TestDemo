//
// WGBEmitterDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/14
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
    

#import "WGBEmitterDemoViewController.h"

@interface WGBEmitterDemoViewController ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

@implementation WGBEmitterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addAnimationCellAction];
}

//添加粒子动画cell
- (void)addAnimationCellAction {
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    //添加粒子图层
    [self.view.layer addSublayer:emitterLayer];
    self.emitterLayer = emitterLayer;
    
    
    
    //发射形状
    // kCAEmitterLayerPoint  点
    // kCAEmitterLayerLine   线性
    // kCAEmitterLayerRectangle  方的
    // kCAEmitterLayerCuboid  立体的
    // kCAEmitterLayerCircle 圆
    // kCAEmitterLayerSphere 球
    
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterMode = kCAEmitterLayerSurface;
    emitterLayer.emitterSize = self.view.frame.size;
    emitterLayer.emitterPosition = CGPointMake(self.view.frame.size.width * 0.5, -10);
    //创建cell
    //动画时长 一个cell的生命周期
    NSTimeInterval animationDuration = 30.0;
    NSMutableArray *cells = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.contents = (id)[[UIImage imageNamed:[self emojiName]] CGImage];
        cell.birthRate = 1.0;
        cell.lifetime = animationDuration;
        cell.speed = 2;
        cell.velocity = 10.f;
        cell.velocityRange = 10.f;
        cell.yAcceleration = 60;
        cell.scale = 1;
        cell.scaleRange = 0.f;
        [cells addObject: cell];
    }
    emitterLayer.emitterCells = cells;
}


- (NSString *)emojiName{
    return [NSString stringWithFormat:@"emoji_%ld",(long)arc4random()%78 + 1];
}

@end
