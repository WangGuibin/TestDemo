//
//  XDZombieProxy.h
//  XDDebugToolKitDev
//
//  Created by SuXinDe on 2018/6/10.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

// 修改自 LXDZombieSniffer
// iOS野指针定位
// https://www.jianshu.com/p/4c8a68bd066c

@interface XDZombieProxy : NSObject
@property (nonatomic, assign) Class originClass;
@end

