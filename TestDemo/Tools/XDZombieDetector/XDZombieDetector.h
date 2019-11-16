//
//  XDZombieDetector.h
//  XDDebugToolKitDev
//
//  Created by SuXinDe on 2018/6/10.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 使用方法：
 设置Bulid phase找到对应的.m文件

 XDZombieDetector.m
 XDZombieProxy.m
 设置 `-fno-objc-arc` 
 
 @interface XDZombieTestViewController ()

 @property (nonatomic, assign) id assignObject;

 @end

 @implementation XDZombieTestViewController

 - (void)viewDidLoad {
     [super viewDidLoad];
     id object = [NSObject new];
     self.assignObject = object;
 
     [XDZombieDetector start];//开启检测野指针
 }

 - (IBAction)zombiePtrDetectClickAction:(id)sender {
      NSLog(@"%@", self.assignObject);
     @try {
         NSLog(@"%@", self.assignObject);
     } @catch (NSException *e) {
         NSLog(@"%@", e);
     } @finally {
         
     }
     
 }
 */
// 修改自 LXDZombieSniffer
// iOS野指针定位
// https://www.jianshu.com/p/4c8a68bd066c

@interface XDZombieDetector : NSObject

+ (void)start;
+ (void)stop;
+ (void)addIgnoreClass:(Class)clazz;

@end

