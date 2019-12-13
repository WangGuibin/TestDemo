//
//  Month.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface Month : NSObject <IGListDiffable>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger days;
@property (nonatomic, strong, readonly) NSDictionary <NSNumber *, NSArray <NSString *> *> *appointments;

- (instancetype)initWithName:(NSString *)name days:(NSInteger)days appointments:(NSDictionary<NSNumber *, NSArray <NSString *> *> *)appointments NS_DESIGNATED_INITIALIZER;
+ (instancetype)monthWithName:(NSString *)name days:(NSInteger)days appointments:(NSDictionary<NSNumber *, NSArray <NSString *> *> *)appointments;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
