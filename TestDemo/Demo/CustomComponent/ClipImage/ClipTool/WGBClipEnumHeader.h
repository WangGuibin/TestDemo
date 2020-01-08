//
// WGBClipEnumHeader.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/1/7
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
    

#ifndef WGBClipEnumHeader_h
#define WGBClipEnumHeader_h

//以哪种类型为参照物进行裁剪
typedef NS_ENUM(NSInteger, WGBClipStyle) {
    WGBClipStyleFrame,
    WGBClipStyleImage
};

//裁剪框样式
typedef NS_ENUM(NSInteger, WGBClipBorderType) {
    WGBClipBorderTypeRound,
    WGBClipBorderTypeRectangle,
    WGBClipBorderTypeTriangle
};

//拖动区域
typedef NS_OPTIONS(NSInteger, WGBClipBorderDragOptions) {
    WGBClipBorderDragOptionsNone    = 0,      //未知拖动区域
    WGBClipBorderDragOptionsTop     = 1 << 0, //顶部拖动区域
    WGBClipBorderDragOptionsLeft    = 1 << 1, //左边拖动区域
    WGBClipBorderDragOptionsRight   = 1 << 2, //右边拖动区域
    WGBClipBorderDragOptionsBottom  = 1 << 3  //底部拖动区域
};

#endif /* WGBClipEnumHeader_h */
