//
//  VCTimeProfiler.m
//  VCTimeProfiler
//
//  Created by SuXinDe on 2018/8/6.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "VCTimeProfiler.h"
#import "VCTimeProfilerRecorder.h"
#import "UIViewController+ViewControllerTimeProfiler.h"

@implementation VCTimeProfiler

+ (instancetype)shared {
    static id __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self privateInit];
    }
    return self;
}

- (void)privateInit {
    
}

- (void)start {
    [[VCTimeProfilerRecorder shared] start];
}

- (void)stop {
    [[VCTimeProfilerRecorder shared] stop];
}

@end
