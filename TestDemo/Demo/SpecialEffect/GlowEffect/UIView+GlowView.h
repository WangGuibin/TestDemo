//
// UIView+GlowView.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/23
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

@interface UIView (GlowView)
//
//                                     == 动画时间解析 ==
//
//  0.0 ------------- 0.0 ------------> glowOpacity [-------------] glowOpacity ------------> 0.0
//           T                 T                           T                          T
//           |                 |                           |                          |
//           |                 |                           |                          |
//           .                 .                           .                          .
//     hideDuration  glowAnimationDuration           glowDuration            glowAnimationDuration
//

#pragma mark - 设置辉光效果

/**
 *  辉光的颜色
 */
@property (nonatomic, strong) UIColor  *glowColor;

/**
 *  辉光的透明度
 */
@property (nonatomic, strong) NSNumber *glowOpacity;

/**
 *  辉光的阴影半径
 */
@property (nonatomic, strong) NSNumber *glowRadius;

#pragma mark - 设置辉光时间间隔

/**
 *  一次完整的辉光周期（从显示到透明或者从透明到显示），默认1s
 */
@property (nonatomic, strong) NSNumber *glowAnimationDuration;

/**
 *  保持辉光时间（不设置，默认为0.5s）
 */
@property (nonatomic, strong) NSNumber *glowDuration;

/**
 *  不显示辉光的周期（不设置默认为0.5s）
 */
@property (nonatomic, strong) NSNumber *hideDuration;

#pragma mark - 辉光相关操作

/**
 *  创建出辉光layer
 */
- (void)createGlowLayer;

/**
 *  插入辉光的layer
 */
- (void)insertGlowLayer;

/**
 *  移除辉光的layer
 */
- (void)removeGlowLayer;

/**
 *  显示辉光
 */
- (void)glowToshow;

/**
 *  隐藏辉光
 */
- (void)glowToHide;

/**
 *  开始循环辉光
 */
- (void)startGlowLoop;
@end

NS_ASSUME_NONNULL_END
