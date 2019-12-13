//
//  SelectionModel.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SelectionModel.h"

@implementation SelectionModel

- (instancetype)initWithOptions:(NSArray<NSString *> *)options type:(SelectionModelType)type
{
    self = [super init];
    if (self) {
        _options = options;
        _type = type;
    }
    return self;
}

+ (instancetype)selectionModelWithOptions:(NSArray<NSString *> *)options type:(SelectionModelType)type {
    return [[self alloc] initWithOptions:options type:type];
}

+ (instancetype)selectionModelWithOptions:(NSArray<NSString *> *)options {
    return [[self alloc] initWithOptions:options type:SelectionModelTypeNone];
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    return self == object;
}

@end
