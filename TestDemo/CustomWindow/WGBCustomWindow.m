//
// WGBCustomWindow.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/26
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
    
#ifndef kNavBarHeight
#define kNavBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + 44)
#endif

#ifndef KWIDTH
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef KHIGHT
#define KHIGHT [UIScreen mainScreen].bounds.size.height
#endif


#import "WGBCustomWindow.h"

static WGBCustomWindow *customWindow = nil;

@implementation WGBCustomWindow
{
    //拖动按钮的起始坐标点
    CGPoint _touchPoint;
    //起始按钮的x,y值
    CGFloat _touchBtnX;
    CGFloat _touchBtnY;
}


+ (instancetype)shareInstanceWindow {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customWindow = [[WGBCustomWindow alloc] initWithFrame:CGRectZero];
        customWindow.type = WGBAssistiveTouchTypeAuto;
    });
    return customWindow;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.frame = CGRectMake(200, 200, 100 , 100);
    }
    return self;
}

- (void)setType:(WGBAssistiveTouchType)type{
    _type = type;
}


- (void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    if (contentView) {
        while (customWindow.subviews.count) {
            [customWindow.subviews.lastObject removeFromSuperview];
        }
        if (!customWindow.subviews.count) {
            [customWindow addSubview:contentView];
            CGFloat itemW = contentView.frame.size.width;
            CGFloat itemH = contentView.frame.size.height;
            CGFloat itemX = KWIDTH - itemW;
            CGFloat itemY = (KHIGHT - itemH)/2.0f;
            customWindow.frame = CGRectMake(itemX, itemY, itemW , itemH);
            contentView.frame = customWindow.bounds;
        }
    }
}

- (void)show{
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    if (customWindow.hidden) {
        customWindow.hidden = NO;
    }else if (!customWindow) {
        customWindow = [WGBCustomWindow shareInstanceWindow];
        customWindow.rootViewController = [UIViewController new];
    }
    customWindow.backgroundColor = [UIColor clearColor];
    [customWindow makeKeyAndVisible];
    customWindow.windowLevel = UIWindowLevelStatusBar + 1001;
    [currentKeyWindow makeKeyWindow];
}

- (void)dismiss{
    customWindow.hidden = YES;
}

#pragma mark - button move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    _touchBtnX = self.frame.origin.x;
    _touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    //偏移量(当前坐标 - 起始坐标 = 偏移量)
    CGFloat offsetX = currentPosition.x - _touchPoint.x;
    CGFloat offsetY = currentPosition.y - _touchPoint.y;
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
    
    //父试图的宽高
    CGFloat superViewWidth = KWIDTH;
    CGFloat superViewHeight = KHIGHT;
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
    
    //x轴左右极限坐标
    if (btnX > superViewWidth){
        //按钮右侧越界
        CGFloat centerX = superViewWidth - btnW/2;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnX < 0){
        //按钮左侧越界
        CGFloat centerX = btnW * 0.5;
        self.center = CGPointMake(centerX, centerY);
    }
    
    //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
    CGFloat defaultNaviHeight = 64;
    CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
    
    //y轴上下极限坐标
    if (btnY <= 0){
        //按钮顶部越界
        centerY = btnH * 0.7;
        self.center = CGPointMake(centerX, centerY);
    }
    else if (btnY > judgeSuperViewHeight){
        //按钮底部越界
        CGFloat y = superViewHeight - btnH * 0.5;
        self.center = CGPointMake(btnX, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    CGFloat minDistance = 2;
    
    //结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - _touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - _touchBtnY) > minDistance;
    
    if (isOverX || isOverY) {
        //超过移动范围就不响应点击 - 只做移动操作
        [self touchesCancelled:touches withEvent:event];
    }else{
        [super touchesEnded:touches withEvent:event];
    }
    
    //按钮靠近右侧
    switch (self.type) {

        case WGBAssistiveTouchTypeAuto:{

            //自动识别贴边
            if (self.center.x >= KWIDTH/2) {

                [UIView animateWithDuration:0.25 animations:^{
                    //按钮靠右自动吸边
                    CGFloat btnX = KWIDTH - self.frame.size.width;
                    self.frame = CGRectMake(btnX, btnY, self.frame.size.width, self.frame.size.height);
                }];
            }else{

                [UIView animateWithDuration:0.25 animations:^{
                    //按钮靠左吸边
                    CGFloat btnX = 0;
                    self.frame = CGRectMake(btnX, btnY, self.frame.size.width, self.frame.size.height);
                }];
            }
            break;
        }
        case WGBAssistiveTouchTypeNearLeft:{
            [UIView animateWithDuration:0.25 animations:^{
                //按钮靠左吸边
                CGFloat btnX = 0;
                self.frame = CGRectMake(btnX, btnY, self.frame.size.width, self.frame.size.height);
            }];
            break;
        }
        case WGBAssistiveTouchTypeNearRight:{
            [UIView animateWithDuration:0.25 animations:^{
                //按钮靠右自动吸边
                CGFloat btnX = KWIDTH - self.frame.size.width;
                self.frame = CGRectMake(btnX, btnY, self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}

@end
