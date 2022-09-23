//
//  LeaderObject.h
//  ResponsibilityChain
//
//  Created by 王贵彬 on 2022/5/7.
//  Copyright © 2022 neotvfbt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeaveModel.h"

NS_ASSUME_NONNULL_BEGIN

//领导--抽象类
@interface LeaderObject : NSObject

// 下一位
@property (nonatomic,strong) LeaderObject *nextLeader;
@property (nonatomic,strong,readonly) LeaveModel *leave;

//走批假流程
- (void)handleLeaveFlow:(LeaveModel *)leave;

//能否有权限处理此事
- (BOOL)canDealWithAction;
//批假
- (void)handleLeave;

@end

/// 组长批3天假期
/// 主管批7天假期
/// CEO批7天假期以上
@interface GroupLeader : LeaderObject

@end

@interface ChargeLeader : LeaderObject

@end

@interface CEOLeader : LeaderObject

@end


NS_ASSUME_NONNULL_END
