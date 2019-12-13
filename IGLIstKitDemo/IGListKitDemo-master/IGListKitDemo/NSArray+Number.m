//
//  NSArray+Number.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "NSArray+Number.h"

@implementation NSArray (Number)

+ (instancetype)arrayWithNumber:(NSNumber *)number {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        [array addObject:[NSNumber numberWithInteger:i]];
    }
    
    return [array copy];
}

+ (instancetype)arrayWithFrom:(NSUInteger)from to:(NSUInteger)to {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = from; i < to; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    return [array copy];
}
@end

