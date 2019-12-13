//
//  Month.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "Month.h"

@implementation Month

- (instancetype)initWithName:(NSString *)name days:(NSInteger)days appointments:(NSDictionary<NSNumber *,NSArray<NSString *> *> *)appointments
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _days = days;
        _appointments = appointments;
    }
    return self;
}

+ (instancetype)monthWithName:(NSString *)name days:(NSInteger)days appointments:(NSDictionary<NSNumber *,NSArray<NSString *> *> *)appointments {
    return [[self alloc] initWithName:name days:days appointments:appointments];
}

- (id<NSObject>)diffIdentifier {
    return _name;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return true;
}
@end
