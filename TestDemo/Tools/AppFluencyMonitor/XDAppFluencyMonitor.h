//
//  XDAppFluencyMonitor.h
//  XDAppFluencyMonitorDemo
//
//  Created by suxinde on 16/8/5.
//  Copyright © 2016年 com.su. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  基于NSRunLoop监听主线程卡顿工具类
 */
@interface XDAppFluencyMonitor : NSObject

@property (nonatomic, assign) BOOL logsEnabled;

+ (instancetype)sharedInstance;

/**
 *  开启监听
 */
- (void)startMonitoring;

/**
 *  关闭监听
 */
- (void)stopMonitoring;

@end

