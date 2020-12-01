//
//  NSString+Emotion.h
//  TwitterListDemo
//
//  Created by bjovov on 2017/11/29.
//  Copyright © 2017年 Cao Xueliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emotion)
/// 将字符串转化为表情,匹配URL,匹配电话号码
- (NSMutableAttributedString *)convertToEmotionWithFont:(UIFont *)font normalColor:(UIColor *)color;
@end
