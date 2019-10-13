//
//  NSArray+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(WGBExtension)

- (NSArray *)removeFirstObject;
- (NSArray *)removeLastObject;

- (NSArray *)addObject:(id)obj;
- (NSArray *)insertObject:(id)obj withIndex:(NSUInteger)index;

- (NSArray *)map:(id(^)(id value))map;
- (NSArray *)filter:(id(^)(id value))filter;

@end
