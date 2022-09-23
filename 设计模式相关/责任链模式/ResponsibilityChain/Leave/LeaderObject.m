//
//  LeaderObject.m
//  ResponsibilityChain
//
//  Created by 王贵彬 on 2022/5/7.
//  Copyright © 2022 neotvfbt. All rights reserved.
//

#import "LeaderObject.h"

@interface LeaderObject ()

@property (nonatomic,strong) LeaveModel *leave;

@end

@implementation LeaderObject

- (void)handleLeaveFlow:(LeaveModel *)leave{
    self.leave = leave;
    if ([self canDealWithAction]) {
        [self handleLeave];
    }else{
        [self handleLeave];//经手人上报
        [self.nextLeader handleLeaveFlow:leave];
    }
}

- (BOOL)canDealWithAction{
    return NO;
}

- (void)handleLeave {
    //子类重写
}

- (LeaderObject *)nextLeader{
    return nil;
}

@end

@implementation GroupLeader

- (BOOL)canDealWithAction{
    return self.leave.days > 0 && self.leave.days <= 3;
}

- (void)handleLeave{
    if ([self canDealWithAction]) {
        NSLog(@"请假 %ld 天,组长审批通过",self.leave.days);
    }else{
        NSLog(@"超出组长审批权限 往上报🔼");
    }
}

- (LeaderObject *)nextLeader{
    return [ChargeLeader new];
}

@end

@implementation ChargeLeader
- (BOOL)canDealWithAction{
    return self.leave.days > 3 && self.leave.days <= 7;
}

- (void)handleLeave{
    if ([self canDealWithAction]) {
        NSLog(@"请假 %ld 天,主管审批通过",self.leave.days);
    }else{
        NSLog(@"超出主管审批权限 往上报🔼");
    }
}

- (LeaderObject *)nextLeader{
    return [CEOLeader new];
}

@end

@implementation CEOLeader
- (BOOL)canDealWithAction{
    return self.leave.days > 7;
}
- (void)handleLeave{
    NSLog(@"请假 %ld 天,CEO审批通过",self.leave.days);
}
@end

