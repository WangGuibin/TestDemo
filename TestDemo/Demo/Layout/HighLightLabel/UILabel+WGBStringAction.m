//
// UILabel+WGBStringAction.m
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
*/
    

#import "UILabel+WGBStringAction.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

/// 存储对象
@interface WGBAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic) NSRange range;

@end

@implementation WGBAttributeModel

@end

@implementation UILabel (WGBStringAction)

/// 数组、字典需要开辟空间
- (NSMutableArray *)strings
{
    NSMutableArray *strings = objc_getAssociatedObject(self, _cmd);
    if (!strings) {
        strings = [NSMutableArray arrayWithCapacity:0];
        objc_setAssociatedObject(self, @selector(strings), strings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return strings;
}

- (NSMutableDictionary *)effectDic
{
    NSMutableDictionary *effectDic = objc_getAssociatedObject(self, _cmd);
    if (!effectDic) {
        effectDic = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return effectDic;
}

- (void)setIsTapAction:(BOOL)isTapAction
{
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isTapAction
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsTapAnimated:(BOOL)isTapAnimated
{
    objc_setAssociatedObject(self, @selector(isTapAnimated), @(isTapAnimated), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isTapAnimated
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


/*
 动态添加属性, 关联对象
 */

/// 是否打开点击效果, 默认打开
- (void)setEnableTapAnimated:(BOOL)enableTapAnimated
{
    objc_setAssociatedObject(self, @selector(enableTapAnimated), @(enableTapAnimated), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enableTapAnimated
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


/// 点击高亮色, 默认是[UIColor lightGrayColor] 需打开enableTapAnimated才有效
- (void)setTapHighlightedColor:(UIColor *)tapHighlightedColor
{
    objc_setAssociatedObject(self, @selector(tapHighlightedColor), tapHighlightedColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)tapHighlightedColor
{
    UIColor * color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

/// 是否扩大点击范围, 默认是打开
- (void)setEnlargeTapArea:(BOOL)enlargeTapArea
{
    objc_setAssociatedObject(self, @selector(enlargeTapArea), @(enlargeTapArea), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enlargeTapArea
{
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = @(YES);
        objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_ASSIGN);
    }
    return [number boolValue];
}

/* ************* block、delegate回调  *************** */
/// block
- (void (^)(UILabel *, NSString *, NSRange, NSInteger))tapBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTapBlock:(void (^)(UILabel *, NSString *, NSRange, NSInteger))tapBlock
{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/// delegate
- (id<WGBStringActionDelegate>)delegate
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDelegate:(id<WGBStringActionDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}


/* ************* 实现api  *************** */

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)wgb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                tapClicked:(void (^) (UILabel * label, NSString *string, NSRange range, NSInteger index))tapClick
{
    
    /// 先移除所有action
    [self wgb_removeAttributeTapActions];
    
    /// 截取范围
    [self wgb_getRangesWithStrings:strings];
    
    self.userInteractionEnabled = YES;
    
    if (!self.tapBlock) {
        self.tapBlock = tapClick;
    }
}

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)wgb_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                  delegate:(id <WGBStringActionDelegate> )delegate
{
    self.delegate = delegate;
}


/**
 *  删除label上的点击事件
 */
- (void)wgb_removeAttributeTapActions
{
    self.tapBlock = nil;
    self.delegate = nil;
    [self.effectDic removeAllObjects];
    self.isTapAction = NO;
    [self.strings removeAllObjects];
}

#pragma mark - 响应事件, touchBegin
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始点击");
    
    if (!self.isTapAction) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    if (self.enableTapAnimated) { /// 是否打开点击效果
        self.isTapAnimated = self.enableTapAnimated;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self wgb_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        
        NSLog(@"string: %@", string);
        
        if (weakSelf.isTapAnimated) {
            
            [weakSelf wgb_saveEffectDicWithRange:range];
            
            [weakSelf wgb_tapEffectWithStatus:YES];
        }
        
    }];
    
    NSLog(@"ret: %d", ret);
    if (!ret) {
        [super touchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始结束");
    
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    if (self.isTapAnimated) {
        [self performSelectorOnMainThread:@selector(wgb_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self wgb_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wgb_tapAttributeInLabel:string:range:index:)]) {
            [weakSelf.delegate wgb_tapAttributeInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始取消");
    
    if (!self.isTapAction) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    if (self.isTapAnimated) {
        [self performSelectorOnMainThread:@selector(wgb_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak typeof(self) weakSelf = self;
    
    BOOL ret = [self wgb_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(wgb_tapAttributeInLabel:string:range:index:)]) {
            [weakSelf.delegate wgb_tapAttributeInLabel:weakSelf string:string range:range index:index];
        }
    }];
    if (!ret) {
        [super touchesCancelled:touches withEvent:event];
    }
}


#pragma mark - getTapFrame
- (BOOL)wgb_getTapFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGFloat total_height =  [self wgb_textSizeWithAttributedString:self.attributedText width:self.bounds.size.width numberOfLines:0].height;
    
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    CGPoint origins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = [self wgb_transformForCoreText];
    
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CGRect flippedRect = [self wgb_getLineBounds:line point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        CGFloat lineOutSpace = (self.bounds.size.height - total_height) / 2;
        
        rect.origin.y = lineOutSpace + [self wgb_getLineOrign:line];
        
        /// 放大点击范围
        if (self.enlargeTapArea) {
            rect.origin.y -= 5;
            rect.size.height += 10;
        }
        
        if (CGRectContainsPoint(rect, point)) {
            
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat offset;
            
            CTLineGetOffsetForStringIndex(line, index, &offset);
            
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            
            NSInteger link_count = self.strings.count;
            
            for (int j = 0; j < link_count; j++) {
                
                WGBAttributeModel *model = self.strings[j];
                
                NSRange link_range = model.range;
                /// 定位点击的字符串
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (CGAffineTransform)wgb_transformForCoreText
{
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)wgb_getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
        attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
    }
    height = [self wgb_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)wgb_getLineOrign:(CTLineRef)line
{
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0.;
    }else {
        NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
        }
        return [self wgb_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    }
}

- (CGSize)wgb_textSizeWithAttributedString:(NSAttributedString *)attributedString width:(float)width numberOfLines:(NSInteger)numberOfLines
{
    @autoreleasepool {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLabel.numberOfLines = numberOfLines;
        sizeLabel.attributedText = attributedString;
        CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        return fitSize;
    }
}


#pragma mark - tapEffect
- (void)wgb_tapEffectWithStatus:(BOOL)status
{
    if (self.isTapAnimated) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.tapHighlightedColor range:NSMakeRange(0, subAtt.string.length)];
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)wgb_saveEffectDicWithRange:(NSRange)range
{
    
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}


#pragma mark - getRange
- (void)wgb_getRangesWithStrings:(NSArray <NSString *>  *)strings
{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapAnimated = YES;
    __block  NSString *totalStr = self.attributedText.string;
//    self.strings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSRange range = [totalStr rangeOfString:obj];
        
        if (range.length != 0) {
            
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[weakSelf wgb_getStringWithRange:range]];
            
            NSLog(@"totalStr: %@", totalStr);
            WGBAttributeModel *model = [WGBAttributeModel new];
            model.range = range;
            model.str = obj;
            [weakSelf.strings addObject:model];
            
            NSLog(@"weakSelf.strings: %@", weakSelf.strings);

        }
        
    }];
}

- (void)wgb_getRangesWithRanges:(NSArray <NSString *>  *)ranges
{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    
    self.isTapAction = YES;
    self.isTapAnimated = YES;
    __block  NSString *totalStr = self.attributedText.string;
//    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    [ranges enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = NSRangeFromString(obj);
        NSAssert(totalStr.length >= range.location + range.length, @"NSRange(%ld,%ld) is out of bounds",range.location,range.length);
        NSString * string = [totalStr substringWithRange:range];
        
        WGBAttributeModel *model = [WGBAttributeModel new];
        model.range = range;
        model.str = string;
        [weakSelf.strings addObject:model];
    }];
}

- (NSString *)wgb_getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        
        [string appendString:@" "];
    }
    return string;
}


@end
