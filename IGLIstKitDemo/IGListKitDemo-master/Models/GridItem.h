//
//  GridItem.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface GridItem : NSObject <IGListDiffable>

@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, assign, readonly) NSInteger itemCount;

- (instancetype)initWithColor:(UIColor *)color itemCount:(NSInteger)itemCount NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
