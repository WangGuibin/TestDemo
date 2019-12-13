//
//  User.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface User : NSObject <IGListDiffable>

@property (nonatomic, assign, readonly) NSInteger pk;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *handle;

- (instancetype)initWithPk:(NSInteger)pk name:(NSString *)name handle:(NSString *)handle NS_DESIGNATED_INITIALIZER;
+ (instancetype)userWithPk:(NSInteger)pk name:(NSString *)name handle:(NSString *)handle;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
