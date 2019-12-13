//
//  DemoItem.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DemoItem.h"

@implementation DemoItem

- (instancetype)initWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier {
    self = [super init];
    if (self) {
        _name = [name copy];
        _controllerClass = [controllerClass copy];
        _controllerIdentifier = [controllerIdentifier copy];
    }
    return self;
}

+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier {
    return [[self alloc] initWithName:name controllerClass:controllerClass controllerIdentifier:controllerIdentifier];
}

+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass {
    return [[self alloc] initWithName:name controllerClass:controllerClass controllerIdentifier:nil];
}

- (id<NSObject>)diffIdentifier {
    return _name;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if ([self isEqual:object]) {
        return YES;
    }
    
    if ([(NSObject *)object isKindOfClass:[DemoItem class]]) {
        DemoItem *oobject = (DemoItem *)object;
        return _controllerClass == oobject.controllerClass && [_controllerIdentifier isEqualToString:oobject.controllerIdentifier];
    } else {
        return NO;
    }
    
    
}

@end
