//
//  NSObject+ResponsibilityChain.m
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import "NSObject+ResponsibilityChain.h"
#import <objc/runtime.h>

@implementation NSObject (ResponsibilityChain)

- (void)setResponsibilityChain:(ResponsibilityChain *)responsibilityChain {
    
    responsibilityChain.object = self;
    objc_setAssociatedObject(self, @selector(responsibilityChain), responsibilityChain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ResponsibilityChain *)responsibilityChain {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
