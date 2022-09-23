//
//  PHXGLocationManager.h
//  LocationDemo
//
//  Created by 王贵彬  on 2022/6/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHXGLocationManager : NSObject

/// 单例
+ (PHXGLocationManager *)defaultManager;

//定位授权状态
@property (nonatomic, assign, readonly) CLAuthorizationStatus authorizationStatus;

/// 定位结果回调
- (void)locationCompletedHandler:(void(^)(NSArray<CLLocation*>*locations,NSError *error))handler;

/// 请求定位授权  会先弹应用使用期间/仅一次/不允许弹窗 1s后弹使用期间/永久授权弹窗
- (void)requestLocationAuthorization:(void(^)(NSError *error))handler;

/// 开启更新定位
- (void)startUpdatingLocation;
/// 停止更新定位
- (void)stopUpdatingLocation;
/// 请求临时定位 有延时(前台大概10s左右/后台超过10s)
- (void)requestLocation;

@end

NS_ASSUME_NONNULL_END
