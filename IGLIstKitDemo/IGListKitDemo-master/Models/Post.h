//
//  Post.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface Post : NSObject <IGListDiffable>

@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSArray<NSString *> *comments;

- (instancetype)initWithUserName:(NSString *)userName comments:(NSArray<NSString *> *)comments NS_DESIGNATED_INITIALIZER;
+ (instancetype)postWithUserName:(NSString *)userName comments:(NSArray<NSString *> *)comments;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
