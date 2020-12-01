//
//  EmoticonHelper.h
//  EmotionKeyboard
//
//  Created by bjovov on 2017/11/15.
//  Copyright © 2017年 caoxueliang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EmoticonGroup;
@interface EmoticonHelper : NSObject
/// 微博图片资源 bundle
+ (NSBundle *)bundle;

/// 微博表情资源 bundle
+ (NSBundle *)emoticonBundle;

/// 微博表情 Array<WBEmotionGroup> (实际应该做成动态更新的)
+ (NSArray<EmoticonGroup *> *)emoticonGroups;

/// 从微博 bundle 里获取图片 (如果不加缓存的话会特别卡)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (如果不加缓存的话会特别卡)
+ (UIImage *)imageWithPath:(NSString *)path;

/// 匹配URL
+ (NSRegularExpression *)regexURL;

/// 匹配电话号码
+ (NSRegularExpression *)regexPhone;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;

@end
