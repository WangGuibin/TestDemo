//
//  ResponsibilityChain.m
//  DJQ_iOS_Service
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import "ResponsibilityChain.h"

@implementation ResponsibilityChain

- (ResponsibilityMessage *)canPassThrough {
    
    ResponsibilityMessage *message = [ResponsibilityMessage new];
    message.checkSuccess           = YES;
    message.object                 = self.object;
    
    return message;
}

@end
