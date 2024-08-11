//
//  AFNTool.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock) (id result);//成功调用的block
typedef void (^FailureBlock) (NSError *error);//失败调用的block
@interface AFNTool : NSObject

//POST请求
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
//GET请求
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
//监测网络状态
+(void)NetworkMonitoring:(void(^)(BOOL zhuang))zha;

@end
