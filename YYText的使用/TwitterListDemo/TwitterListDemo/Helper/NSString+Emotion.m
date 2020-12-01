//
//  NSString+Emotion.m
//  TwitterListDemo
//
//  Created by bjovov on 2017/11/29.
//  Copyright © 2017年 Cao Xueliang. All rights reserved.
//

#import "NSString+Emotion.h"
#import <YYText/YYText.h>
#import "EmoticonHelper.h"

@implementation NSString (Emotion)
- (NSMutableAttributedString *)convertToEmotionWithFont:(UIFont *)font normalColor:(UIColor *)color{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:self];
    text.yy_color = color;
    text.yy_font = font;
    
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    // 匹配URL
    NSArray<NSTextCheckingResult *> *urlResults = [[EmoticonHelper regexURL] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *url in urlResults) {
        if (url.range.location == NSNotFound && url.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text yy_setColor:[UIColor blueColor] range:url.range];
            
            //设置高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            
            //数据信息，用于稍后用户点击
            highlight.userInfo = @{kWBLinkURLName : [text.string substringWithRange:url.range]};
            [text yy_setTextHighlight:highlight range:url.range];
        }
    }
    
    
    // 匹配电话号码
    NSArray<NSTextCheckingResult *> *phoneResult = [[EmoticonHelper regexPhone] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *phone in phoneResult) {
        if (phone.range.location == NSNotFound && phone.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:phone.range.location] == nil) {
            [text yy_setColor:[UIColor blueColor] range:phone.range];
            
            //设置高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            
            //数据信息，用于稍后用户点击
            highlight.userInfo = @{KWBLinkPhone : [text.string substringWithRange:phone.range]};
            [text yy_setTextHighlight:highlight range:phone.range];
        }
    }
    
    
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[EmoticonHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [EmoticonHelper emoticonDic][emoString];
        UIImage *image = [EmoticonHelper imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:font.pointSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}

@end

