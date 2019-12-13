//
//  IncrementAnnouncer.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IncrementAnnouncer;

@protocol IncrementListener <NSObject>

- (void)didIncrement:(IncrementAnnouncer *)announcer value:(NSInteger)value;

@end

@interface IncrementAnnouncer : NSObject

- (void)addListener:(id<IncrementListener>)listener;
- (void)increment;

@end
