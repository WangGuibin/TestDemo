//
//  IncrementAnnouncer.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "IncrementAnnouncer.h"

@implementation IncrementAnnouncer {
    NSInteger _value;
    NSHashTable <id<IncrementListener>> *_map;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _map = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)addListener:(id<IncrementListener>)listener {
    [_map addObject:listener];
}

- (void)increment {
    _value++;
    for (id<IncrementListener> listener in _map) {
        [listener didIncrement:self value:_value];
    }
}
@end
