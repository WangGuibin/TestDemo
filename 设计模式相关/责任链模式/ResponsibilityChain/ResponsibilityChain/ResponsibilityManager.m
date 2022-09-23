//
//  ResponsibilityManager.m
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import "ResponsibilityManager.h"

@interface ResponsibilityManager ()

@property (nonatomic, strong) NSMutableArray *storeChains;

@end

@implementation ResponsibilityManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.storeChains = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)chains {
    
    return [NSArray arrayWithArray:self.storeChains];
}

- (void)addChain:(NSObject *)object {
    
    NSParameterAssert(object.responsibilityChain);
    [self.storeChains addObject:object];
}

- (void)removeChain:(NSObject *)object {
    
    NSParameterAssert(object.responsibilityChain);
    [self.storeChains removeObject:object];
}

- (ResponsibilityMessage *)checkResponsibilityChain {
    
    ResponsibilityMessage *message = nil;
    
    for (NSObject *chain in self.storeChains) {
        
        message = [chain.responsibilityChain canPassThrough];
        if (message.checkSuccess == NO) {
            
            break;
        }
    }
    
    return message;
}

@end
