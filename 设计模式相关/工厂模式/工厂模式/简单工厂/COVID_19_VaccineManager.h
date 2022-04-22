//
//  COVID_19_VaccineManager.h
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import "COVID_19_VaccineProtocol.h"

//对外输出都是疫苗种类 具体是怎么生产的 哪里生产的 接种的人并不关心

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, COVID_19_VaccineType) {
    COVID_19_VaccineType_BeijingOrg,
    COVID_19_VaccineType_KeXing
};

@interface COVID_19_VaccineManager : NSObject

+ (id<COVID_19_VaccineProtocol>)injectionCOVID_19_VaccineWithType:(COVID_19_VaccineType)type;

+ (void)printInfo:(id<COVID_19_VaccineProtocol>)obj;

@end

NS_ASSUME_NONNULL_END
