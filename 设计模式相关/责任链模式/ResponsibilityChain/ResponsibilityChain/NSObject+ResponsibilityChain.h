//
//  NSObject+ResponsibilityChain.h
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponsibilityChain.h"

@interface NSObject (ResponsibilityChain)

@property (nonatomic, strong) ResponsibilityChain *responsibilityChain;

@end
