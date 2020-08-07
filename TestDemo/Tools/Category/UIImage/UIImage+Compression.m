//
// UIImage+Compression.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/8/7
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
    

#import "UIImage+Compression.h"

@implementation UIImage (Compression)
+ (NSData *)smartCompressImage:(UIImage *)image {
    /** LUBAN 算法 **/
    // https://github.com/Curzibn/Luban/blob/master/library/src/main/java/top/zibin/luban/Engine.java
    //    int size = 1;
    //    float scale = ((float) shortSide / longSide);
    //    if (scale <= 1 && scale > 0.5625) {
    //        if (longSide < 1664) {
    //            size = 1;
    //        } else if (longSide >= 1664 && longSide < 4990) {
    //            size = 2;
    //        } else if (longSide > 4990 && longSide < 10240) {
    //            size = 4;
    //        } else {
    //            size = longSide / 1080 == 0 ? 1 : longSide / 1080;
    //        }
    //    } else if (scale <= 0.5625 && scale > 0.5) {
    //        size = longSide / 1080 == 0 ? 1 : longSide / 1080;
    //    } else {
    //        size = (int) ceil(longSide / (1080.0 / scale));
    //    }
    
    //    CGSize compressSize = CGSizeMake(width / size, height / size);
    
    //    CGFloat compression = 1.0;
    //    CGFloat maxCompression = 0.1;
    //
    //    //We loop into the image data to compress accordingly to the compression ratio
    //    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    //    while ([imageData length] > 110 * 1024 && compression > maxCompression) {
    //        compression -= 0.10;
    //        imageData = UIImageJPEGRepresentation(image, compression);
    //    }
    //
    //    return imageData;
    
    /** 仿微信算法 **/
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    int updateWidth = width;
    int updateHeight = height;
    int longSide = MAX(width, height);
    int shortSide = MIN(width, height);
    float scale = ((float) shortSide / longSide);
    
    // 大小压缩
    if (shortSide < 1080 || longSide < 1080) { // 如果宽高任何一边都小于 1080
        updateWidth = width;
        updateHeight = height;
    } else { // 如果宽高都大于 1080
        if (width < height) { // 说明短边是宽
            updateWidth = 1080;
            updateHeight = 1080 / scale;
        } else { // 说明短边是高
            updateWidth = 1080 / scale;
            updateHeight = 1080;
        }
    }
    
    CGSize compressSize = CGSizeMake(updateWidth, updateHeight);
    UIGraphicsBeginImageContext(compressSize);
    [image drawInRect:CGRectMake(0,0, compressSize.width, compressSize.height)];
    UIImage *compressImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 质量压缩 50%
    NSData *compressData = UIImageJPEGRepresentation(compressImage, 0.5);
    
    return compressData;
}
@end
