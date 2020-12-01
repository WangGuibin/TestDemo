//
//  EmoticonHelper.m
//  EmotionKeyboard
//
//  Created by bjovov on 2017/11/15.
//  Copyright © 2017年 caoxueliang.cn. All rights reserved.
//

#import "EmoticonHelper.h"
#import "EmoticonGroup.h"
#import <YYCategories/YYCategories.h>
#import <YYModel/YYModel.h>

@implementation EmoticonHelper
+ (NSBundle *)bundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (NSBundle *)emoticonBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    });
    return bundle;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"WeiboImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image yy_imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image = [[self imageCache] objectForKey:path];
    if (image) return image;
    if (path.pathScale == 1) {
        // 查找 @2x @3x 的图片
        NSArray *scales = [NSBundle preferredScales];
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        image = [image yy_imageByDecoded];
        [[self imageCache] setObject:image forKey:path];
    }
    return image;
}

+ (NSRegularExpression *)regexURL{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern: @"((http|ftp|https)://)?(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexPhone{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern: @"1[3578][0-9]{9}" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
    });
    return dic;
}

+ (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    /*按照表情名字--->表情图片保存到字典*/
    NSArray *array = @[@"com.sina.default",@"com.sina.lxh"];
    NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        NSString *path = [emoticonBundlePath stringByAppendingPathComponent:str];
        NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
        EmoticonGroup *singleGroup = [EmoticonGroup yy_modelWithJSON:info];
        for (Emoticon *emotion in singleGroup.emoticons) {
            NSString *pngPath = [path stringByAppendingPathComponent:emotion.png];
            dic[emotion.chs] = pngPath;
            dic[emotion.cht] = pngPath;
        }
    }];
    return dic;
}

+ (NSArray<EmoticonGroup *> *)emoticonGroups {
    static NSMutableArray *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*获取EmoticonWeibo下的 plist文件*/
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"emoticons.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
        NSArray *packages = plist[@"packages"];
        
        /*获取emoji,default,lxh三个文件夹下的图片*/
        NSMutableArray *tmpArray = [NSMutableArray new];
        for (int i = 0; i < packages.count; i++) {
            NSString *fileName = [packages[i] valueForKey:@"id"];
            NSString *path = [emoticonBundlePath stringByAppendingPathComponent:fileName];
            NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
            EmoticonGroup *singleGroup = [EmoticonGroup yy_modelWithJSON:info];
            [tmpArray addObject:singleGroup];
        }
        groups = [tmpArray mutableCopy];
    });
    return groups;
}

@end


