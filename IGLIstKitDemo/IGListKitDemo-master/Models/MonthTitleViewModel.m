//
//  MonthTitleViewModel.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "MonthTitleViewModel.h"

@implementation MonthTitleViewModel

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = [name copy];
    }
    return self;
}

+ (instancetype)monthTitleViewModelWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (id<NSObject>)diffIdentifier {
    return _name;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) {
        return YES;
    }
    
    if ([(NSObject *)object isKindOfClass:[MonthTitleViewModel class]]) {
        return YES;
    }
    
    return NO;
}
@end
