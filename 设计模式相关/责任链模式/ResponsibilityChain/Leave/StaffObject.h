//
//  StaffObject.h
//  ResponsibilityChain
//
//  Created by 王贵彬 on 2022/5/7.
//  Copyright © 2022 neotvfbt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//员工
@interface StaffObject : NSObject

- (void)sendLeaveRequest:(NSUInteger)leaveDays;

@end

NS_ASSUME_NONNULL_END
