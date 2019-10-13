//
//  UIImage+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WGBExtension)
// 模糊效果(渲染很耗时间,建议在子线程中渲染)
- (UIImage *)blurImage;
- (UIImage *)blurImageWithMask:(UIImage *)maskImage;
- (UIImage *)blurImageWithRadius:(CGFloat)radius;
- (UIImage *)blurImageAtFrame:(CGRect)frame;

// 灰度效果
- (UIImage *)grayScale;

// 固定宽度与固定高度
- (UIImage *)scaleWithFixedWidth:(CGFloat)width;
- (UIImage *)scaleWithFixedHeight:(CGFloat)height;

// 平均的颜色
- (UIColor *)averageColor;

// 裁剪图片的一部分
- (UIImage *)croppedImageAtFrame:(CGRect)frame;

// 将自身填充到指定的size
- (UIImage *)fillClipSize:(CGSize)size;



///矫正图片方向
+ (UIImage*)fixOrientation:(UIImage*)aImage ;

///MARK:-生成纯色图片
+ (UIImage *)createImageWithColor:(UIColor *)color;

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth ;

//拉伸图片
- (UIImage *)stretchableImage;

- (UIImage*)imageBlackToTransparent:(UIImage*)image;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 * 裁剪 圆边框
 *
 *@参数1: image  原图
 *@参数2: border  边框宽度
 *@参数3: borderColor 边框颜色
 */

+ (instancetype)imageClipBorder:(UIImage*)image border:(CGFloat)border borderColor:(UIColor *)borderColor;
/**
 * 给图片设置水印
 *
 *@参数1: image  原图
 *@参数2: waterText 水印文字
 *@参数3: point 水印绘制开始的点
 *@参数4: textDict 水印文本属性字典 如:    @{
 NSFontAttributeName :[UIFont systemFontOfSize:15],
 NSForegroundColorAttributeName:[UIColor redColor]
 }
 */
+ (instancetype)imageAddWaterLabel:(UIImage*)image waterText:(NSString*)waterText waterTextDrawPoint:(CGPoint)point andTextAttributes:(NSDictionary*)textDict;

/**
 * 截屏
 *
 *@参数1: captureView  要截屏的当前视图
 */
+ (instancetype)imageCapture:(UIView*)captureView;



@end
