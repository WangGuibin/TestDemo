//
// WGBCreateQRCodeTool.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/23
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
    

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBCreateQRCodeTool : NSObject

/**
生成颜色二维码

@param content 二维码数据
@param size 二维码大小
@param logo 二维码中心logo
@param logoFrame logo大小
@param red 0 ~ 1.0
@param green 0 ~ 1.0
@param blue 0 ~ 1.0
@return 生成颜色二维码图片
*/
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;

/**
创建并设置二维码尺寸大小

@param content 原始二维码数据
@param size 设置二维码尺寸大小
@return 二维码图片
*/
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size;

/**
生成颜色条形码

@param content 条形码数据
@param size 条形码大小
@param red 0 ~ 1.0
@param green 0 ~ 1.0
@param blue 0 ~ 1.0
@return 条形码图片
*/
+ (UIImage *)barcodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue;

/**
 设置条形码尺寸大小

 @param content 原始条形码数据
 @param size 条形码大小
 @return 条形码图片
 */
+ (UIImage *)barcodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
