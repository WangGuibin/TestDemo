//
// WGBCAEmitterBehaviorDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/4
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
    

#import "WGBCAEmitterBehaviorDemoViewController.h"
#import "WGBConfettiTypeModel.h"
#import "CAEmitterBehavior.h"

@interface WGBCAEmitterBehaviorDemoViewController ()

@property (nonatomic, strong) NSMutableArray<WGBConfettiTypeModel*> *confettiTypes;
@property (nonatomic, strong) CAEmitterLayer *confettiLayer;
@property (nonatomic, strong) NSMutableArray<CAEmitterCell*> *cells;

@end

@implementation WGBCAEmitterBehaviorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view.layer addSublayer:self.confettiLayer];
    [self addBehaviors];
    [self addAnimations];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)addBehaviors{
    [self.confettiLayer setValue:@[[self horizontalWaveBehavior],[self verticalWaveBehavior],[self attractorBehaviorWithLayer:self.confettiLayer]] forKey:@"emitterBehaviors"];
}

- (void)addAnimations{
    [self addAttractorAnimationWithLayer:self.confettiLayer];
    [self addBirthrateAnimationWithLayer:self.confettiLayer];
}

- (CAEmitterBehavior *)horizontalWaveBehavior{
    CAEmitterBehavior *behavior = [CAEmitterBehavior behaviorWithType:kCAEmitterBehaviorWave];
    [behavior setValue:@[@(100),@(0),@(0)] forKey:@"force"];
    [behavior setValue:@(0.5) forKey:@"frequency"];
    return behavior;
}

- (CAEmitterBehavior *)verticalWaveBehavior{
    CAEmitterBehavior *behavior = [CAEmitterBehavior behaviorWithType:kCAEmitterBehaviorWave];
    [behavior setValue:@[@(0),@(500),@(0)] forKey:@"force"];
    [behavior setValue:@(3) forKey:@"frequency"];
    return behavior;
}

- (CAEmitterBehavior *)attractorBehaviorWithLayer:(CAEmitterLayer *)emitterLayer{    CAEmitterBehavior *behavior = [CAEmitterBehavior behaviorWithType:kCAEmitterBehaviorAttractor];
    [behavior setValue:@"attractor"  forKey:@"name"];
    [behavior setValue:@(-290) forKey:@"falloff"];
    [behavior setValue:@(300) forKey:@"radius"];
    [behavior setValue:@(10) forKey:@"stiffness"];
    [behavior setValue:[NSValue valueWithCGPoint:CGPointMake(emitterLayer.emitterPosition.x, emitterLayer.emitterPosition.y + 20)] forKey:@"position"];
    [behavior setValue:@(-70) forKey:@"zPosition"];
    return behavior;
}

- (void)addAttractorAnimationWithLayer:(CALayer *)layer{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 3;
    animation.keyTimes = @[@(0),@(0.4)];
    animation.values = @[@(80), @(5)];
    [layer addAnimation:animation forKey:@"emitterBehaviors.attractor.stiffness"];
}

- (void)addBirthrateAnimationWithLayer:(CALayer *)layer{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 1;
    animation.fromValue = @1;
    animation.toValue = @0;
    [layer addAnimation:animation forKey:@"birthRate"];
}

///MARK:- lazy load
- (NSMutableArray<WGBConfettiTypeModel*> *)confettiTypes {
    if (!_confettiTypes) {
        _confettiTypes = [[NSMutableArray<WGBConfettiTypeModel*> alloc] init];
        NSArray *colors = @[
            RGB(149, 58, 255),RGB(255, 195, 41),RGB(255, 101, 26),
            RGB(123, 92, 255),RGB(76, 126, 255),RGB(71, 192, 255),
            RGB(255, 47, 39),RGB(255, 91, 134),RGB(233, 122, 208)
        ];
        
        [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger index, BOOL * _Nonnull stop) {
            for (NSInteger i = 0; i < 2; i++) {
                for (NSInteger j = 0; j < 2; j++) {
                    WGBConfettiTypeModel *model = [[WGBConfettiTypeModel alloc] initWithColor:color shape:i position:j];
                    [_confettiTypes addObject: model];
                }
            }
        }];
        
    }
    return _confettiTypes;
}


- (CAEmitterLayer *)confettiLayer {
    if (!_confettiLayer) {
        _confettiLayer = [CAEmitterLayer layer];
        _confettiLayer.emitterCells = self.cells;
        _confettiLayer.emitterPosition = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
        _confettiLayer.emitterSize = CGSizeMake(100, 100);
        _confettiLayer.emitterShape = kCAEmitterLayerSphere;
        _confettiLayer.frame = self.view.bounds;
        _confettiLayer.birthRate = 0;
        _confettiLayer.beginTime = CACurrentMediaTime();
    }
    return _confettiLayer;
}


- (NSMutableArray<CAEmitterCell*> *)cells {
    if (!_cells) {
        _cells = [[NSMutableArray<CAEmitterCell*> alloc] init];
        for (WGBConfettiTypeModel *model in self.confettiTypes) {
            CAEmitterCell *cell = [[CAEmitterCell alloc] init];
            cell.beginTime = 0.1;
            cell.birthRate = 10;
            cell.contents = (__bridge id _Nullable)(model.image.CGImage);
            cell.emissionRange = M_PI;
            cell.lifetime = 10;
            cell.spin = 4;
            cell.spinRange = 8;
//            cell.velocityRange = 100;
//            cell.yAcceleration = 150;
            cell.velocityRange = 0;
            cell.yAcceleration = 0;
            cell.birthRate = 100;
            [cell setValue:@"plane" forKey:@"particleType"];
            [cell setValue:@(M_PI) forKey:@"orientationRange"];
            [cell setValue:@(M_PI/2.0) forKey:@"orientationLongitude"];
            [cell setValue:@(M_PI/2.0) forKey:@"orientationLatitude"];
            [_cells addObject:cell];
        }
    }
    return _cells;
}

@end
