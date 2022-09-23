//
//  PHXGLocationManager.m
//  LocationDemo
//
//  Created by 王贵彬  on 2022/6/10.
//

#import "PHXGLocationManager.h"

@interface PHXGLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,copy) void(^authorizationErrorBlock) (NSError *error);
@property (nonatomic,copy) void (^locationResultBlock)(NSArray<CLLocation *>*locations,NSError *error);


@end

@implementation PHXGLocationManager

+ (PHXGLocationManager*)defaultManager{
    static PHXGLocationManager *_manager;
    static dispatch_once_t instanceToken;
    dispatch_once(&instanceToken, ^{
        _manager = [[self alloc] init];
        [_manager initLocation];
    });
    return _manager;
}

- (void)initLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    //允许后台定位
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    //是否显示定位蓝色图标
    if (@available(iOS 11.0, *)) {
        self.locationManager.showsBackgroundLocationIndicator = NO;
    }
    
//   百度提供了 kCLLocationAccuracyBest 参数，设置该参数可以获取到精度在10m左右的定位结果，但是相应的需要付出比较长的时间（10s左右），越高的精度需要持续定位时间越长。
//   推荐使用kCLLocationAccuracyHundredMeters，一次还不错的定位，偏差在百米左右，超时时间设置在2s-3s左右即可。

    // 设置定位精度，十米，百米，最好
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //每隔多少米定位一次（这里的设置为任何的移动）即坐标过滤 这里设置为不过滤
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //是否允许系统自动暂停定位功能，设置为YES进行后台定位时，系统检测到长时间没有位置更新的时候，将会暂停定位功能，当app进入前台时会恢复定位功能
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.delegate = self; //代理设置
}

- (void)requestLocationAuthorization:(void (^)(NSError * _Nonnull))handler{
    if (![CLLocationManager locationServicesEnabled]) {
        !handler? : handler([[NSError alloc] initWithDomain:@"com.ph.xg.ios" code:666666 userInfo:@{NSLocalizedDescriptionKey:@"定位服务未打开,请检查⌜系统设置>隐私>定位服务⌟权限是否开启"}]);
        return;
    }
    
    if([self locationServiceIsValid] == NO){
        !handler? : handler([[NSError alloc] initWithDomain:@"com.ph.xg.ios" code:666666 userInfo:@{NSLocalizedDescriptionKey:@"用户已拒绝该app使用定位服务"}]);
        return;
    }
    //判断当前定位权限是否ok,如果没有定位权限，则需要先申请定位权限
    if([self authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self requestLocationAuthorizationIfNeed:self.locationManager];
    }
    self.authorizationErrorBlock = handler;
}

- (void)requestLocation{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager requestLocation];
}

- (void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationCompletedHandler:(void (^)(NSArray<CLLocation *> * _Nonnull, NSError * _Nonnull))handler{
    self.locationResultBlock = handler;
}

//获取当前定位权限
- (CLAuthorizationStatus)authorizationStatus{
    if (@available(iOS 14.0, *)) {
        return self.locationManager.authorizationStatus;
    } else {
        return [CLLocationManager authorizationStatus];
    }
}

//当前应用是否可以使用/申请定位服务
- (BOOL)locationServiceIsValid{
    if ([self authorizationStatus] == kCLAuthorizationStatusDenied ||
        [self authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

//当前定位状态是否可用
- (BOOL)locationAuthStatusIsValid{
    if ([self locationServiceIsValid] == NO) {
        return  NO;
    }
    if ([self authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

//请求定位权限，
- (void)requestLocationAuthorizationIfNeed:(CLLocationManager *)manager{
    //系统版本号
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //系统版本8+ && 没有选择过定位权限
    if (systemVersion > 7.99 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        //获取info.plist中配置字段信息
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        BOOL hasAlwaysAndWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil;
        //如果是iOS11及以后
        if (@available(iOS 11.0, *)){
            [manager requestWhenInUseAuthorization];
//            if (hasAlwaysAndWhenInUseKey && hasWhenInUseKey){
//                //如果plist同时配置两个字段，则两个权限申请API都可以调用；
//                //建议直接调用requestAlwaysAuthorization即可
//                [manager requestAlwaysAuthorization];
//            }else if (hasWhenInUseKey){
//                //如果plist只配置InUseKey，则只能调用使用时API
//                [manager requestWhenInUseAuthorization];
//            }else{
//                NSLog(@"要在iOS11及以上版本使用定位服务, 需要在Info.plist中添加NSLocationAlwaysAndWhenInUseUsageDescription和NSLocationWhenInUseUsageDescription字段。");
//            }
            if (!hasWhenInUseKey || !hasAlwaysAndWhenInUseKey) {
                !self.authorizationErrorBlock? : self.authorizationErrorBlock([[NSError alloc] initWithDomain:@"com.ph.xg.ios" code:666666 userInfo:@{NSLocalizedDescriptionKey:@"要在iOS11及以上版本使用定位服务, 需要在Info.plist中添加NSLocationAlwaysAndWhenInUseUsageDescription和NSLocationWhenInUseUsageDescription字段。"}]);
            }
            
        }else{
            if (hasAlwaysKey){
                //如果plist配置hasAlwaysKey，则可以调用始终允许API
                [manager requestAlwaysAuthorization];
            }else if (hasWhenInUseKey){
                //如果plist配置hasAlwaysKey，则可以调用始终允许API
                [manager requestWhenInUseAuthorization];
            }else{
                !self.authorizationErrorBlock? : self.authorizationErrorBlock([[NSError alloc] initWithDomain:@"com.ph.xg.ios" code:666666 userInfo:@{NSLocalizedDescriptionKey:@"要在iOS8到iOS10版本使用定位服务, 需要在Info.plist中添加NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription字段。"}]);
//                NSLog(@"要在iOS8到iOS10版本使用定位服务, 需要在Info.plist中添加NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription字段。");
            }
        }
    }
}

//iOS13及以前版本回调
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [manager requestAlwaysAuthorization];
        });
    }
}

//iOS14及以后版本回调
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    if (@available(iOS 14.0, *)) {
        if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [manager requestAlwaysAuthorization];
            });
        }
    }
}

//成功获取到经纬度
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    !self.locationResultBlock? : self.locationResultBlock(locations,nil);
}

// 定位失败错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    !self.locationResultBlock? : self.locationResultBlock(@[],error);
}

@end
