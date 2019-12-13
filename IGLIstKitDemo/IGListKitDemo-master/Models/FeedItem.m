//
//  FeedItem.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

- (instancetype)initWithPk:(NSInteger)pk user:(User *)user comments:(NSArray<NSString *> *)comments
{
    self = [super init];
    if (self) {
        _pk = pk;
        _user = user;
        _comments = comments;
    }
    return self;
}

+ (instancetype)feedItemWithPk:(NSInteger)pk user:(User *)user comments:(NSArray<NSString *> *)comments {
    return [[self alloc] initWithPk:pk user:user comments:comments];
}

- (id<NSObject>)diffIdentifier {
    return [NSNumber numberWithInteger:_pk];
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if ([self isEqual:object]) {
        return YES;
    }
    
    if (object == nil || ![(NSObject *)object isKindOfClass:[FeedItem class]]) {
        return NO;
    }
    
    return [_user isEqualToDiffableObject:((FeedItem *)object).user] && [_comments isEqualToArray:((FeedItem *)object).comments];
}

@end
