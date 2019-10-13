//
//  NSArray+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "NSArray+WGBExtension.h"

@implementation NSArray (WGBExtension)

- (NSArray *)removeFirstObject{
    NSMutableArray *dataArray = [self mutableCopy];
    [dataArray removeObjectAtIndex:0];
    return dataArray;
}
- (NSArray *)removeLastObject{
    NSMutableArray *dataArray = [self mutableCopy];
    [dataArray removeObjectAtIndex: dataArray.count-1];
    return dataArray;
}

- (NSArray *)addObject:(id)obj{
    NSMutableArray *dataArray = [self mutableCopy];
    [dataArray addObject: obj];
    return dataArray;
}

- (NSArray *)insertObject:(id)obj withIndex:(NSUInteger)index{
    NSMutableArray *dataArray = [self mutableCopy];
    [dataArray insertObject: obj atIndex: index];
    return dataArray;
}

- (NSArray *)map:(id(^)(id value))map{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (id obj in self) {
        [dataArray addObject: map(obj)];
    }
    return dataArray;
}

- (NSArray *)filter:(id(^)(id value))filter{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (id obj in self) {
        if (![self containsObject: filter(obj)]) {
            continue;
        }
        [dataArray addObject: obj];
    }
    return dataArray;
}
@end
