//
//  DayViewModel.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface DayViewModel : NSObject <IGListDiffable>

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL today;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger appointments;

- (instancetype)initWithDay:(NSInteger)day today:(BOOL)today selected:(BOOL)selected appointment:(NSInteger)appointment NS_DESIGNATED_INITIALIZER;
+ (instancetype)dayViewModelWithDay:(NSInteger)day today:(BOOL)today selected:(BOOL)selected appointment:(NSInteger)appointment;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
