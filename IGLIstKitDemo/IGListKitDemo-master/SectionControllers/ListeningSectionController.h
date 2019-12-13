//
//  ListeningSectionController.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "IncrementAnnouncer.h"

@interface ListeningSectionController : IGListSectionController <IncrementListener>

- (instancetype)initWithAnnouncer:(IncrementAnnouncer *)announcer NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
