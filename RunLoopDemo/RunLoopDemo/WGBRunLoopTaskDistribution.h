//
//  WGBRunLoopTaskDistribution.h
//  RunLoopDemo
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 参考了以下开源库改造而成
 https://github.com/qiaoyoung/RunLoop
 https://github.com/diwu/RunLoopWorkDistribution
 
 */
NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^WGBRunLoopTaskDistributionUnit)(void);

@interface WGBRunLoopTaskDistribution : NSObject

@property (nonatomic, assign) NSUInteger maxTaskCount;// 最大任务数 默认50

//任务分配 单例
+ (instancetype)sharedRunLoopTaskDistribution;
//添加任务
- (void)addTask:(WGBRunLoopTaskDistributionUnit)unit withKey:(id)key;
//移除所有任务
- (void)removeAllTasks;

@end


@interface UITableViewCell (WGBRunLoopTaskDistribution)

@property (nonatomic, strong) NSIndexPath *rl_currentIndexPath;

@end


NS_ASSUME_NONNULL_END
