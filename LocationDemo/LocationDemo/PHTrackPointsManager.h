//
//  PHTrackPointsManager.h
//  LocationDemo
//
//  Created by 王贵彬  on 2022/6/22.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, PHLocationCoordType) {
    PHLocationCoordTypeWGS84, //wgs84 GPS国际标准坐标 苹果自带的这种
    PHLocationCoordTypeBD09LL, //百度坐标
    PHLocationCoordTypeGCJ02 //国测局02火星坐标
};


NS_ASSUME_NONNULL_BEGIN

@interface PHTrackPointsManager : NSObject

/// 单例
+ (PHTrackPointsManager *)shareManager;


//默认wgs84
@property (nonatomic,assign) PHLocationCoordType coordType;
//定位实时回调(wgs84) 苹果返回啥就回调啥 
@property (nonatomic,copy) void(^currentLocationBlock) (CLLocation *location);

/// 开始采集点
/// @param entityName 采集一个标识
- (void)startWithEntryName:(NSString *)entityName;
/// 停止本次采集
- (void)stop;


/// 暂停采集
- (void)pause;
/// 恢复采集
- (void)resume;

//调试打印
@property (nonatomic,copy) void (^printInfo) (NSString *msg);

@end

NS_ASSUME_NONNULL_END
