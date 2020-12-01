//
//  EmoticonGroup.m
//  EmotionKeyboard
//
//  Created by bjovov on 2017/11/15.
//  Copyright © 2017年 caoxueliang.cn. All rights reserved.
//

#import "EmoticonGroup.h"

@implementation Emoticon
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}
@end

@implementation EmoticonGroup
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"nameCN" : @"group_name_cn",
             @"nameEN" : @"group_name_en",
             @"nameTW" : @"group_name_tw",
             @"displayOnly" : @"display_only",
             @"groupType" : @"group_type"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emoticons" : [Emoticon class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emoticons enumerateObjectsUsingBlock:^(Emoticon *emoticon, NSUInteger idx, BOOL *stop) {
        emoticon.group = self;
    }];
    return YES;
}
@end
