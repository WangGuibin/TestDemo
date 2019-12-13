//
//  Post.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithUserName:(NSString *)userName comments:(NSArray<NSString *> *)comments
{
    self = [super init];
    if (self) {
        _userName = userName;
        _comments = comments;
    }
    return self;
}

+ (instancetype)postWithUserName:(NSString *)userName comments:(NSArray<NSString *> *)comments {
    return [[self alloc] initWithUserName:userName comments:comments];
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object;
}
@end
