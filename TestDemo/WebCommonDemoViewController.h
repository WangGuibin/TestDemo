//
//  WebCommonDemoViewController.h
//  TestDemo
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WGBWebRequestType) {
    WGBWebRequestTypeGET,
    WGbWebRequestTypePOST
};


NS_ASSUME_NONNULL_BEGIN

@interface WebCommonDemoViewController : UIViewController


- (instancetype)initWithURLString:(NSString *)urlStr navgationBarTitle:(NSString *)tittle ;

/**
 统一网页接口
 @param requestType 请求的方法 GET或者POST
 @param parametersDict 参数字典
 @param url 网址
 @param title 标题
 @return 网页实例
 */
- (instancetype)initWithMethodType:(WGBWebRequestType)requestType
                        parameters:(NSDictionary *)parametersDict
                               url:(NSString *)url
                             title:(NSString *)title ;


@end

NS_ASSUME_NONNULL_END
