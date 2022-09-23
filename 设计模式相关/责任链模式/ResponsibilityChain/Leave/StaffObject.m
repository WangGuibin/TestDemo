//
//  StaffObject.m
//  ResponsibilityChain
//
//  Created by 王贵彬 on 2022/5/7.
//  Copyright © 2022 neotvfbt. All rights reserved.
//

#import "StaffObject.h"
#import "LeaderObject.h"

@implementation StaffObject

//发起请假请求
- (void)sendLeaveRequest:(NSUInteger)leaveDays{
    LeaveModel *model = [LeaveModel new];
    model.days = leaveDays;
    //员工需要请假 需要有一个反馈渠道或者审批链路
    //通过组长为切入点,如果组长权限足够处理就直接处理了,权限不够则层层逐级上报
    //对于普通员工,只需向组长反馈即可,内部逻辑根据权限与请假天数进行分配审批角色
    GroupLeader *group = [GroupLeader new];
    [group handleLeaveFlow:model];
}

@end
