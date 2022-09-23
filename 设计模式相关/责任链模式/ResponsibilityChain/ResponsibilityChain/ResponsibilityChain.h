//
//  ResponsibilityChain.h
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponsibilityMessage.h"

@interface ResponsibilityChain : NSObject

/**
 The object to attach.
 */
@property (nonatomic, weak) id object;

/**
 Overwrite by subclass.
 
 @return Can pass through or not.
 */
- (ResponsibilityMessage *)canPassThrough;

@end
