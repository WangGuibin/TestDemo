//
// WGBClipFrameView.m
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
    

#import "WGBClipFrameView.h"
#import "WGBClipBorderView.h"

@interface WGBClipFrameView()
{
    //裁剪框最小宽高
    CGFloat _minClipBorderWH;
}

//源图片容器
@property (nonatomic, strong) UIImageView *originImgView;
//裁剪框
@property (nonatomic, strong) WGBClipBorderView *clipBorder;
//蒙层遮罩
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) WGBClipBorderDragOptions currentDragOption;

@end


@implementation WGBClipFrameView

@synthesize borderType = _borderType;
@synthesize aspectRatio = _aspectRatio;
@synthesize originImage = _originImage;

#pragma mark - lazy loading
- (UIImageView *)originImgView
{
    if (_originImgView == nil)
    {
        _originImgView = [[UIImageView alloc] init];
        _originImgView.userInteractionEnabled = YES;
    }
    return _originImgView;
}

- (UIView *)maskView
{
    if (_maskView == nil)
    {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _maskView;
}

- (WGBClipBorderView *)clipBorder
{
    if (_clipBorder == nil)
    {
        _clipBorder = [[WGBClipBorderView alloc] init];
    }
    return _clipBorder;
}


///MARK: - <WGBClipImageProtocol>
- (void)setupContainerSubViews{
    _minClipBorderWH = 15 * 3 + 2;
    
    [self addSubview:self.originImgView];
    [self.originImgView addSubview:self.maskView];
    [self.originImgView addSubview:self.clipBorder];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureHandle:)];
    [self.clipBorder addGestureRecognizer:panGesture];
}

- (void)layoutContainerSubViews{
    //防止在IB上计算为0，导致显示出现问题bug
    CGFloat imageWidth = MAX(self.originImage.size.width, 1);
    CGFloat imageHeight = MAX(self.originImage.size.height, 1);
    if (imageWidth > imageHeight)
    {
        CGFloat originImgHeight = self.frame.size.width * imageHeight / imageWidth;
        self.originImgView.frame = CGRectMake(0, (self.frame.size.height - originImgHeight) * 0.5, self.frame.size.width, originImgHeight);
    } else {
        CGFloat originImgWidth = self.frame.size.height * imageWidth / imageHeight;
        self.originImgView.frame = CGRectMake((self.frame.size.width - originImgWidth) * 0.5, 0, originImgWidth, self.frame.size.height);
    }
    [self resetClipViewAndMaskViewFrame];
}

- (UIImage *)getClipedResultImage
{
    CGFloat scaleFactorX = self.originImage.size.width * self.originImage.scale / self.originImgView.frame.size.width;
    CGFloat scaleFactorY = self.originImage.size.height * self.originImage.scale / self.originImgView.frame.size.height;
    
    CGRect rect = CGRectMake(self.clipBorder.frame.origin.x * scaleFactorX, self.clipBorder.frame.origin.y * scaleFactorY, self.clipBorder.frame.size.width * scaleFactorX, self.clipBorder.frame.size.height * scaleFactorY);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.originImage CGImage], rect);
    UIImage* newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, 0);
    UIBezierPath *clipPath = [UIBezierPath bezierPath];
    if (self.borderType == WGBClipBorderTypeRound)
    {
        clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
    }else if (self.borderType == WGBClipBorderTypeRectangle){
        clipPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, newImage.size.width , newImage.size.height)];
    }else {
        [clipPath moveToPoint:CGPointMake(newImage.size.width * 0.5, 0)];
        [clipPath addLineToPoint:CGPointMake(0, newImage.size.height)];
        [clipPath addLineToPoint:CGPointMake(newImage.size.width, newImage.size.height)];
        [clipPath closePath];
    }
    [clipPath addClip];
    [newImage drawAtPoint:CGPointZero];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - event
- (void)onPanGestureHandle:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translationPos = [panGesture translationInView:panGesture.view];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    CGPoint locationPos = [panGesture locationInView:panGesture.view];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.currentDragOption = [self.clipBorder getClipBorderDragOptions:locationPos];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.currentDragOption & WGBClipBorderDragOptionsTop)
            {
                //往上translation.y小于0，所以高度会增加,y会减小
                CGRect currentRect = panGesture.view.frame;
                CGFloat changeHeight = currentRect.size.height - translationPos.y;
                //获取高度最大最小值
                CGFloat maxHeight = CGRectGetMaxY(currentRect);
                CGFloat minHeight = _minClipBorderWH;
                CGFloat resultHeight = MIN(maxHeight, MAX(minHeight, changeHeight));
                currentRect.origin.y = CGRectGetMaxY(currentRect) - resultHeight;
                currentRect.size.height = resultHeight;
                panGesture.view.frame = currentRect;
            }
            if (self.currentDragOption & WGBClipBorderDragOptionsLeft) {
                //往左translation.x小于0，所以宽度会增加,x会减小
                CGRect currentRect = panGesture.view.frame;
                CGFloat changeWidth = currentRect.size.width - translationPos.x;
                //获取宽度最大最小值
                CGFloat maxWidth = CGRectGetMaxX(currentRect);
                CGFloat minWidth = _minClipBorderWH;
                CGFloat resultWidth = MIN(maxWidth, MAX(minWidth, changeWidth));
                currentRect.origin.x = CGRectGetMaxX(currentRect) - resultWidth;
                currentRect.size.width = resultWidth;
                panGesture.view.frame = currentRect;
            }
            if (self.currentDragOption & WGBClipBorderDragOptionsRight) {
                //往右translation.x大于0，所以宽度会增加
                CGRect currentRect = panGesture.view.frame;
                CGFloat changeWidth = currentRect.size.width + translationPos.x;
                //获取宽度最大最小值
                CGFloat maxWidth = self.originImgView.frame.size.width - currentRect.origin.x;
                CGFloat minWidth = _minClipBorderWH;
                CGFloat resultWidth = MIN(maxWidth, MAX(minWidth, changeWidth));
                currentRect.size.width = resultWidth;
                panGesture.view.frame = currentRect;
            }
            if (self.currentDragOption & WGBClipBorderDragOptionsBottom) {
                //往下translation.y大于0，所以宽度会增加
                CGRect currentRect = panGesture.view.frame;
                CGFloat changeHeight = currentRect.size.height + translationPos.y;
                //获取高度最大最小值
                CGFloat maxHeight = self.originImgView.frame.size.height - currentRect.origin.y;
                CGFloat minHeight = _minClipBorderWH;
                CGFloat resultHeight = MIN(maxHeight, MAX(minHeight, changeHeight));
                currentRect.size.height = resultHeight;
                panGesture.view.frame = currentRect;
            }
            if (self.currentDragOption == WGBClipBorderDragOptionsNone) {
                CGPoint changeCenter = CGPointMake(panGesture.view.center.x + translationPos.x, panGesture.view.center.y + translationPos.y);
                //计算出centerX的最大最小值
                CGFloat minCenterX = panGesture.view.frame.size.width * 0.5;
                CGFloat maxCenterX = self.originImgView.frame.size.width - panGesture.view.frame.size.width * 0.5;
                //计算出centerY的最大最小值
                CGFloat minCenterY = panGesture.view.frame.size.height * 0.5;
                CGFloat maxCenterY = self.originImgView.frame.size.height - panGesture.view.frame.size.height * 0.5;
                panGesture.view.center = CGPointMake(MIN(maxCenterX, MAX(minCenterX, changeCenter.x)), MIN(maxCenterY, MAX(minCenterY, changeCenter.y)));
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            self.currentDragOption = WGBClipBorderDragOptionsNone;
        }
            break;
            
        default:
            break;
    }
    [self resetClipWindowTransparentArea];
}

#pragma mark - setter
- (void)setAspectRatio:(CGFloat)aspectRatio
{
    _aspectRatio = aspectRatio;
    [self layoutContainerSubViews];
}

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    self.originImgView.image = originImage;
    [self layoutContainerSubViews];
}

- (void)setBorderType:(WGBClipBorderType)borderType{
    _borderType = borderType;
    [self layoutContainerSubViews];
}

#pragma mark - private methods
- (void)resetClipViewAndMaskViewFrame
{
    if (CGSizeEqualToSize(self.originImage.size, CGSizeZero)) return;
    CGFloat clipWindowWidth = 0;
    CGFloat clipWindowHeight = 0;
    CGFloat imageWidth = self.originImgView.frame.size.width;
    CGFloat imageHeight = self.originImgView.frame.size.height;
    if (imageWidth > imageHeight) //横向
    {
        if (self.aspectRatio > 1 && imageHeight * self.aspectRatio > imageWidth)
        {
            clipWindowWidth = self.originImgView.frame.size.width * 3 / 4.0;
            clipWindowHeight = clipWindowWidth / self.aspectRatio;
        } else {
            clipWindowHeight = imageHeight * 3 / 4.0;
            clipWindowWidth = clipWindowHeight * self.aspectRatio;
        }
    } else {
        if (self.aspectRatio < 1 && self.aspectRatio < imageHeight < imageWidth)
        {
            clipWindowHeight = self.originImgView.frame.size.height * 3 / 4.0;
            clipWindowWidth = clipWindowHeight * self.aspectRatio;
        } else {
            clipWindowWidth = imageWidth * 3 / 4.0;
            clipWindowHeight = clipWindowWidth / self.aspectRatio;
        }
    }
    self.clipBorder.frame = CGRectMake((self.originImgView.frame.size.width - clipWindowWidth) * 0.5, (self.originImgView.frame.size.height - clipWindowHeight) * 0.5, clipWindowWidth, clipWindowHeight);
    self.maskView.frame = self.originImgView.bounds;
    self.clipBorder.borderType = self.borderType;
    [self resetClipWindowTransparentArea];
}

- (void)resetClipWindowTransparentArea
{
    if (self.maskLayer && self.maskLayer.superlayer)
    {
        [self.maskLayer removeFromSuperlayer];
    }
    self.maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.maskView.bounds];
    UIBezierPath *clearPath;
    switch (self.borderType) {
        case WGBClipBorderTypeRectangle:
        {
            clearPath = [[UIBezierPath bezierPathWithRect:self.clipBorder.frame] bezierPathByReversingPath];
        }
            break;
        case WGBClipBorderTypeRound:
        {
            clearPath = [[UIBezierPath bezierPathWithOvalInRect:self.clipBorder.frame] bezierPathByReversingPath];
        }
            break;
        case WGBClipBorderTypeTriangle:
        {
            clearPath = [[UIBezierPath bezierPath] bezierPathByReversingPath];
            [clearPath moveToPoint:CGPointMake(CGRectGetMidX(self.clipBorder.frame), CGRectGetMinY(self.clipBorder.frame))];
            [clearPath addLineToPoint:CGPointMake(CGRectGetMinX(self.clipBorder.frame), CGRectGetMaxY(self.clipBorder.frame))];
            [clearPath addLineToPoint:CGPointMake(CGRectGetMaxX(self.clipBorder.frame), CGRectGetMaxY(self.clipBorder.frame))];
            [clearPath closePath];
        }
            break;
            
        default:
            break;
    }
    [path appendPath:clearPath];
    self.maskLayer.path = path.CGPath;
    self.maskView.layer.mask = self.maskLayer;
}

@end
