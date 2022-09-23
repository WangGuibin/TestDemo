//
//  PHTrackPointsManager.m
//  LocationDemo
//
//  Created by 王贵彬  on 2022/6/22.
//

#import "PHTrackPointsManager.h"
#import "PHXGLocationManager.h"
#import "HZLocationConverter.h"

@interface PHTrackPointsManager ()

@property (nonatomic,strong) PHXGLocationManager *locationManager;
@property (nonatomic,copy) NSString *entity_name;
@property (nonatomic,assign) BOOL isCanLocation;//能否定位📌
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CLLocation *lastLocation;
@property (nonatomic,strong) CLGeocoder *geoCoder;

@end

@implementation PHTrackPointsManager


/// 单例
+ (PHTrackPointsManager *)shareManager{
    static PHTrackPointsManager *_manager;
    static dispatch_once_t instanceToken;
    dispatch_once(&instanceToken, ^{
        _manager = [[self alloc] init];
        [_manager initConfig];
    });
    return _manager;
}

- (CLGeocoder *)geoCoder{
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)startWithEntryName:(NSString *)entityName{
    NSAssert(entityName != nil, @"entityName 为空,该字段为必传字段");
    if (!entityName || !entityName.length) {
#ifdef DEBUG
        NSLog(@"entityName 为空,该字段为必传字段");
#endif
        return;
    }
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"location.plist"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    self.entity_name = entityName;
    self.isCanLocation = YES;
    [self.locationManager startUpdatingLocation];
}


- (void)stop{
    [self.locationManager stopUpdatingLocation];
    self.isCanLocation = NO;
    [self savePoints];
    self.entity_name = nil;
}

- (void)pause{
    self.isCanLocation = NO;
}

- (void)resume{
    self.isCanLocation = YES;
}

- (void)initConfig{
    self.locationManager = [PHXGLocationManager defaultManager];
    [self.locationManager requestLocationAuthorization:^(NSError * _Nonnull error) {
#ifdef DEBUG
        NSLog(@"%@",error);
#endif
    }];
    [self.locationManager locationCompletedHandler:^(NSArray<CLLocation *> * _Nonnull locations, NSError * _Nonnull error) {
        if (!self.isCanLocation) {
            return;
        }
        
        if (error) {
#ifdef DEBUG
        NSLog(@"%@",error);
#endif
        }else{
            CLLocation *location = locations.firstObject;
            //来一波筛选
            if ([self dropPointWithLocation:location]) {
#ifdef DEBUG
                self.printInfo([NSString stringWithFormat:@"%@,该坐标不符合要求,被过滤了~",location]);
#endif
                return;
            }

            //            BOOL isValidPoint = [self filterPointsWithCurrentLocation:location];
            //            if (!isValidPoint) {
            //                return;
            //            }
                        
            [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                NSString *returnAddress = @"";
                NSString *province = @"";
                NSString *city = @"";
                NSString *placemarkName = @"";
                if (error) {
#ifdef DEBUG
                    self.printInfo(error.localizedDescription);
#endif
                }else{
                    CLPlacemark *placemark = [placemarks lastObject];
                    //                    NSString *placemarkCountry = placemark.country.length > 0 ? placemark.country : @"";//国家
                    province = placemark.administrativeArea.length > 0 ? placemark.administrativeArea : @"";
                    city = placemark.locality.length > 0 ? placemark.locality : @"";
                    NSString *placemarkSubLocality = placemark.subLocality.length > 0 ? placemark.subLocality : @"";
                    placemarkName = placemark.name.length > 0 ? placemark.name : @"";
                    returnAddress = [NSString stringWithFormat:@"%@-%@-%@-%@", province, city,placemarkSubLocality,placemarkName];
#ifdef DEBUG
                    NSMutableString *logStr = @">>>=======================>>>\n".mutableCopy;
                    [logStr appendFormat:@"经纬度: (%@,%@)\n",@(location.coordinate.longitude),@(location.coordinate.latitude)];
                    [logStr appendFormat:@"航向: %@\n",@(location.course)];
                    [logStr appendFormat:@"海拔: %@m\n",@(location.altitude)];
                    [logStr appendFormat:@"速度: %@m/s\n",@(location.speed)];
                    NSDateFormatter *dateformat = [[NSDateFormatter  alloc] init];
                    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                    NSString *dateStr = [dateformat stringFromDate:location.timestamp];
                    [logStr appendFormat:@"时间: %@\n",dateStr];
                    [logStr appendFormat:@"水平误差: %@m\n",@(location.horizontalAccuracy)];
                    [logStr appendFormat:@"地位地址: %@\n",returnAddress];
                    [logStr appendString:@">>>=======================>>>"];
                    self.printInfo(logStr);
#endif
                }
                
                [self convertAndSavePointWithLocation:location
                                             province:province
                                                 city:city
                                        placemarkName:placemarkName];
            }];
            !self.currentLocationBlock? : self.currentLocationBlock(location);
            self.lastLocation = location;
        }
    }];
}

/// 转换坐标并保存
- (void)convertAndSavePointWithLocation:(CLLocation *)location
                               province:(NSString *)province
                                city:(NSString *)city
                          placemarkName:(NSString *)placemarkName{
    //苹果返回的是WGS-84标准坐标 需要转成国测局GCJ-02火星坐标 再转成百度坐标
    CLLocationCoordinate2D gcj02 = [HZLocationConverter transformFromWGSToGCJ:location.coordinate];
    CLLocationCoordinate2D baidu = [HZLocationConverter transformFromGCJToBaidu:gcj02];
    NSString *loc_time = [NSString stringWithFormat:@"%.f",location.timestamp.timeIntervalSince1970];
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;//水平精度 无效则为负值
    
    if (self.coordType == PHLocationCoordTypeGCJ02) {
        NSDictionary *wgs84Dic = @{
            @"coord_type_input":@"gcj02",
            @"entity_name" : self.entity_name,
            @"loc_time": loc_time,
            @"latitude": @(gcj02.latitude),
            @"longitude": @(gcj02.longitude),
            @"course" : @(location.course),
            @"speed" : @(location.speed),
            @"province": province,
            @"city": city,
            @"placemarkName":placemarkName,
            @"horizontalAccuracy":@(horizontalAccuracy)
        };
        [self.dataSource addObject:wgs84Dic];
    }else if(self.coordType == PHLocationCoordTypeWGS84){
        NSDictionary *wgs84Dic = @{
            @"coord_type_input":@"wgs84",
            @"entity_name" : self.entity_name,
            @"loc_time":loc_time,
            @"latitude": @(location.coordinate.latitude),
            @"longitude": @(location.coordinate.longitude),
            @"course" : @(location.course),
            @"speed" : @(location.speed),
            @"province": province,
            @"city": city,
            @"placemarkName":placemarkName,
            @"horizontalAccuracy":@(horizontalAccuracy)
        };
        [self.dataSource addObject:wgs84Dic];

    }else{
        NSDictionary *bdDic = @{
            @"coord_type_input" : @"bd09ll",
            @"entity_name" : self.entity_name,
            @"loc_time":loc_time,
            @"latitude": @(baidu.latitude),
            @"longitude": @(baidu.longitude),
            @"course" : @(location.course),
            @"speed" : @(location.speed),
            @"province": province,
            @"city": city,
            @"placemarkName":placemarkName,
            @"horizontalAccuracy":@(horizontalAccuracy)
        };
        [self.dataSource addObject:bdDic];
    }
    //保存点坐标文件
    [self savePoints];
}

/// 筛选坐标
/// 1. 筛选时间间隔小于5秒就放弃这个点
/// 2. 筛选距离小于定位精度的一半就放弃这个点
- (BOOL)dropPointWithLocation:(CLLocation *)location{
    if (self.lastLocation) {
        NSTimeInterval t1 = self.lastLocation.timestamp.timeIntervalSince1970;
        NSTimeInterval t2 = location.timestamp.timeIntervalSince1970;
        NSTimeInterval t = t2 - t1;
        CLLocationDistance distance = [self.lastLocation distanceFromLocation:location];
        return t1 > t2 || t < 5 || distance < 0.5 *location.horizontalAccuracy;
    }
    return NO;
}

/// 返回当前定位的点坐标是否有效 YES为有效 NO为无效
/// @param location 当前定位
- (BOOL)filterPointsWithCurrentLocation:(CLLocation *)location{
//    GPS定位减小精度误差的几种处理方法
//    https://blog.csdn.net/qq_29098447/article/details/121677863
    BOOL isValidPoint = YES;//默认都是有效的点
    // 水平方向的误差值大于70 则认为GPS信号📶太差
    if (location.horizontalAccuracy > 70)  {
        isValidPoint = NO;
        self.printInfo(@"当前水平误差大于70(GPS信号📶不好),为无效坐标");
    }
    //如果上一个点和当前点的瞬时速度为0 则当前点是无效的
    if (self.lastLocation) {
        if (
            (self.lastLocation.speed == -1 && location.speed == -1) ||
            (self.lastLocation.speed == 0 && location.speed == 0)
            ) {
            isValidPoint = NO;
            self.printInfo(@"当前坐标与上一个坐标的瞬时速度均为0或者-1,判定当前坐标为无效坐标");
        }
        // 两点距离太近 也为无效点 判断依据为 小于 0.5~0.66个水平误差值 这里取0.6
        CLLocationDistance distance = [self.lastLocation distanceFromLocation:location];
        if (distance < 0.6*location.horizontalAccuracy) {
            isValidPoint = NO;
            self.printInfo(@"距离上一次定位坐标距离太近,为无效坐标");
        }
        //        NSTimeInterval duration = location.timestamp.timeIntervalSince1970 - self.lastLocation.timestamp.timeIntervalSince1970;
        //        CLLocationSpeed speed = distance / duration;
        //        //比如跑步，博尔特最快是10.44m/s 这个得看出行方式了
        //        if (speed > 10) {
        //            isValidPoint = NO;
        //        }
        
    }
    return isValidPoint;
}


- (void)savePoints{
    @synchronized (self) {
        if (!self.dataSource.count) {
            return;
        }
        if (self.dataSource.count >= 100 || self.isCanLocation == NO) {
            NSString *fileName = [NSString stringWithFormat:@"%@.plist",self.entity_name];
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
            BOOL res = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSMutableArray *oldArrM = [NSMutableArray arrayWithContentsOfFile:filePath];
                [oldArrM addObjectsFromArray:self.dataSource];
                res = [oldArrM writeToFile:filePath atomically:YES];
                
            }else{
                res = [self.dataSource writeToFile:filePath atomically:YES];
            }
            if (res) {
                [self.dataSource removeAllObjects];
                self.printInfo(@"数据已成功写入");
            }
        }
    }
}


@end
