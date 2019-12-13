//
//  NSArray+Number.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Number)

+ (instancetype)arrayWithNumber:(NSNumber *)number;
+ (instancetype)arrayWithFrom:(NSUInteger)from to:(NSUInteger)to;

@end
