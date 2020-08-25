//
// WGBPopupWrapperView.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/25
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
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WGBPopupViewProtocol <NSObject>

- (UIView *)show:(UIView *)parentView;
- (void)hide;

@end


// 给弹出视图加一个可点击的背景，点击背景视图隐藏
@interface WGBPopupViewWrapper : UIButton <WGBPopupViewProtocol>

- (instancetype)initWithView:(id<WGBPopupViewProtocol>)popupView;

@property (nonatomic, strong) UIColor * _Nullable bgColor;//默认为nil，表示背景透明
@property (nonatomic, copy) void (^ _Nullable hideHandler) (void);//背景及视图消失回调

@end


// 弹出视图需继承自该类
@interface WGBPopupView : UIView <WGBPopupViewProtocol>

@end

@interface WGBPopupObject : NSObject <WGBPopupViewProtocol>

- (void)hide NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
