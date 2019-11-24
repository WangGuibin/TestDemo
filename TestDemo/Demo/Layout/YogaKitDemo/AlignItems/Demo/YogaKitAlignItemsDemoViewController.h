//
// YogaKitAlignItemsDemoViewController.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/24
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

@interface YogaKitAlignItemsDemoViewController : UIViewController

//YGAlignAuto,
//YGAlignFlexStart, 起点对齐
//YGAlignCenter, 中间对齐
//YGAlignFlexEnd, 末尾对齐
//YGAlignStretch, 拉伸至一样齐(前提是垂直方向上的长度值为auto)
//YGAlignBaseline, 基线对齐
//YGAlignSpaceBetween, 子控件间距相等
//YGAlignSpaceAround 所有间距和边距相等

// alignSelf  允许单个item与其他item不一样的对齐方式
// alignItems 比水平方向的justContent多一个YGAlignStretch
// alignContent 分一行和多行  一行的时候和alignItems一致   多行的时候需要有主轴和交叉轴同时存在才生效

/*
1. basic: 固定主轴方向的长度，优先级高于width或者height
2. grow: 空间大，瓜分剩余空间，值越大，瓜分的剩余空间越大
3. shrink: 空间不足，控件压缩规则，值越大，压缩的空间越大
*/


@property (nonatomic,assign) YGAlign flexboxAlign;

@end

NS_ASSUME_NONNULL_END
