//
//  AFNTool.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/22.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "AFNTool.h"

@implementation AFNTool

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    //创建管理者对象
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //设置返回的序列号
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    //请求数据
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    //创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //设置返回的序列号
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    //请求数据
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)NetworkMonitoring:(void (^)(BOOL))zha{
    //开启网络状态监测器
    [[AFNetworkReachabilityManager manager] startMonitoring];
    //获取网络连接的判断结果
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"通过WIFI连接网络");
                zha(YES);
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络连接");
                zha(NO);
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"通过4G网络连接");
                zha(YES);
            }
            default:
                
                break;
        }
    }];
}
@end
