//
//  DemoItem.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

@interface DemoItem : NSObject <IGListDiffable>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) Class controllerClass;
@property (nonatomic, copy, readonly) NSString *controllerIdentifier;

- (instancetype)initWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier NS_DESIGNATED_INITIALIZER;
+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier;
+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
