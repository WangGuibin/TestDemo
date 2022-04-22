//
//  COVID_19_VaccineManager.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "COVID_19_VaccineManager.h"
#import "COVID_19_Vaccine_BeijingOrganism.h"
#import "COVID_19_Vaccine_KeXing.h"


@implementation COVID_19_VaccineManager

+ (id<COVID_19_VaccineProtocol>)injectionCOVID_19_VaccineWithType:(COVID_19_VaccineType)type{
    
    if (type == COVID_19_VaccineType_BeijingOrg) {
        return [COVID_19_Vaccine_BeijingOrganism new];
    }
    
    if (type == COVID_19_VaccineType_KeXing) {
        return [COVID_19_Vaccine_KeXing new];
    }
    return nil;
}

+ (void)printInfo:(id<COVID_19_VaccineProtocol>)obj{
    [obj vaccineName];
    [obj validDate];
    [obj inputTimes];
    [obj limitConditions];
}


@end
