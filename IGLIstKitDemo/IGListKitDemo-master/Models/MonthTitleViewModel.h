//
//  MonthTitleViewModel.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface MonthTitleViewModel : NSObject <IGListDiffable>

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
+ (instancetype)monthTitleViewModelWithName:(NSString *)name;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
