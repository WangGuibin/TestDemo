//
//  ResponsibilityMessage.h
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponsibilityMessage : NSObject

@property (nonatomic, weak)   id object;
@property (nonatomic) BOOL       checkSuccess;
@property (nonatomic, strong) id errorMessage;

@end
