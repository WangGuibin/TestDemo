//
//  GridItem.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "GridItem.h"

@implementation GridItem

- (instancetype)initWithColor:(UIColor *)color itemCount:(NSInteger)itemCount
{
    self = [super init];
    if (self) {
        _color = color;
        _itemCount = itemCount;
    }
    return self;
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object ? YES : [self isEqual:object];
}

@end
