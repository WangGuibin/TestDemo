//
//  Person.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface Person : NSObject <IGListDiffable>

@property (nonatomic, assign, readonly) NSInteger pk;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithPk:(NSInteger)pk name:(NSString *)name NS_DESIGNATED_INITIALIZER;
+ (instancetype)personWithPk:(NSInteger)pk name:(NSString *)name;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
