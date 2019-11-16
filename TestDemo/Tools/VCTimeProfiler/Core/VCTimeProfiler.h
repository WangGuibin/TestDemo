//
//  VCTimeProfiler.h
//  VCTimeProfiler
//
//  Created by SuXinDe on 2018/8/6.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCTimeProfiler : NSObject

+ (instancetype)shared;

- (void)start;
- (void)stop;

@end
