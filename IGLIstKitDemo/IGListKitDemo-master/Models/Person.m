//
//  Person.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "Person.h"

@implementation Person
- (instancetype)initWithPk:(NSInteger)pk name:(NSString *)name
{
    self = [super init];
    if (self) {
        _pk = pk;
        _name = name;
    }
    return self;
}

+ (instancetype)personWithPk:(NSInteger)pk name:(NSString *)name {
    return [[self alloc] initWithPk:pk name:name];
}

- (id<NSObject>)diffIdentifier {
    return [NSNumber numberWithInteger:_pk];
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (object == nil || ![(NSObject *)object isKindOfClass:[Person class]]) {
        return NO;
    }
    
    return [_name isEqualToString:((Person *)object).name];
}

@end
