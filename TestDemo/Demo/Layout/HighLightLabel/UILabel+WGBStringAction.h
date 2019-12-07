//
// UILabel+WGBStringAction.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/7
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
 这个分类代码是我复刻而来的  局限性作用在一行文本
 https://github.com/Nicholas86/PracticeDemo/blob/master/TestDelegate/Demo/CTFrame/viewcontroller/UILabel%2BStringAction.h
*/
    
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol WGBStringActionDelegate <NSObject>
@optional
/**
 *  StringAction
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)wgb_tapAttributeInLabel:(UILabel *)label
                         string:(NSString *)string
                          range:(NSRange)range
                          index:(NSInteger)index;
@end


@interface UILabel (WGBStringAction)


/// 是否打开点击效果, 默认打开
@property (nonatomic, assign) BOOL enableTapAnimated;

/// 点击高亮色, 默认是[UIColor lightGrayColor] 需打开enableTapAnimated才有效
@property (nonatomic, strong) UIColor * tapHighlightedColor;

/// 是否扩大点击范围, 默认是打开
@property (nonatomic, assign) BOOL enlargeTapArea;


/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)wgb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)wgb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <WGBStringActionDelegate> )delegate;


/**
 *  删除label上的点击事件
 */
- (void)wgb_removeAttributeTapActions;

@end

NS_ASSUME_NONNULL_END
