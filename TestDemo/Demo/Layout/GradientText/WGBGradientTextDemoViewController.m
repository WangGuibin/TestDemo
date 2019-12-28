//
// WGBGradientTextDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/28
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
    

#import "WGBGradientTextDemoViewController.h"
#import "WHGradientHelper.h"

@interface WGBGradientTextDemoViewController ()

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) CAGradientLayer *gradientLayer1;


@end

@implementation WGBGradientTextDemoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat offsetY = 120;
    UILabel *label1 = [self createLableWithText:@"第一行文本 mask动态炫彩" offsetY:offsetY];
    self.label1 = label1;
    [self addLabel1GradientLayer];

    offsetY = 180;
    UILabel *label2 = [self createLableWithText:@"第二行文本 mask静态炫彩" offsetY:offsetY];
    [self addLabel2GradientLayerWithLabel: label2];
    
    offsetY = 240;
    UILabel *label3 = [self createLableWithText:@"第三行文本 图片实现炫彩" offsetY:offsetY];
    label3.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_images"]];
    
    offsetY = 300;
    UILabel *label4 = [self createLableWithText:@"第四行文本 keyframe实现动画炫彩" offsetY:offsetY];
    [WHGradientHelper addGradientChromatoAnimationForLableText:self.view lable:label4];
    
    offsetY = 360;
    UILabel *label5 = [self createLableWithText:@"第五行文本 展示线性动画炫彩" offsetY:offsetY];
    [WHGradientHelper addLinearGradientForLableText:self.view lable:label5 start:[UIColor redColor] and:[UIColor greenColor]];
}

- (void)addLabel1GradientLayer{
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    self.gradientLayer1 = gradientLayer;
    gradientLayer.frame = self.label1.frame;
    // 渐变层颜色随机
    gradientLayer.colors = @[(id)[self randomGradientLayerColor].CGColor, (id)[self randomGradientLayerColor].CGColor, (id)[self randomGradientLayerColor].CGColor];
    [self.view.layer addSublayer:gradientLayer];

    // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
    // 设置渐变层的裁剪层
    gradientLayer.mask = self.label1.layer;

     // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层
    // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
    self.label1.frame = gradientLayer.bounds;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(label1TextColorChange)];
    // frameInterval属性是可读可写的NSInteger型值，标识间隔多少帧调用一次selector 方法，默认值是1，即每帧都调用一次。如果每帧都调用一次的话，对于iOS设备来说那刷新频率就是60HZ也就是每秒60次，如果将 frameInterval 设为2 那么就会两帧调用一次，也就是变成了每秒刷新30次。以此类推
    if (@available(iOS 10.0, *)) {
        link.preferredFramesPerSecond = 4;
    }else{
        link.frameInterval = 4;
    }
    // 使用NSRunLoopCommonModes模式，防止页面滑动等操作时不执行方法
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

}

- (void)label1TextColorChange{
    self.gradientLayer1.colors = @[
        (id)[self randomGradientLayerColor].CGColor,
        (id)[self randomGradientLayerColor].CGColor,
        (id)[self randomGradientLayerColor].CGColor,
        (id)[self randomGradientLayerColor].CGColor,
        (id)[self randomGradientLayerColor].CGColor];
}

- (UIColor *)randomGradientLayerColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return ranColor;
}


- (void)addLabel2GradientLayerWithLabel:(UILabel *)label{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor redColor].CGColor,
        (id)[UIColor orangeColor].CGColor,
        (id)[UIColor purpleColor].CGColor,
        (id)[UIColor cyanColor].CGColor,
        (id)[UIColor greenColor].CGColor,
        (id)[self randomGradientLayerColor].CGColor,
        (id)[UIColor blueColor].CGColor
    ];
    gradientLayer.locations = @[@0,@0.2,@0.25,@0.45,@0.55,@0.75, @1];// 默认就是均匀分布
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.frame = label.frame;
    gradientLayer.mask = label.layer;
    label.layer.frame = gradientLayer.bounds;//这一句很关键
    [self.view.layer addSublayer:gradientLayer];
}


- (UILabel *)createLableWithText:(NSString *)text offsetY:(CGFloat)offsetY {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, offsetY, KWIDTH - 100 , 30)];
    label.text = text;
    [self.view addSubview:label];
    return label;
}

@end
