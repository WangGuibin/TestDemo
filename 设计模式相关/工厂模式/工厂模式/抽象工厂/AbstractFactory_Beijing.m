//
//  AbstractFactory_Beijing.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "AbstractFactory_Beijing.h"
#import "COVID_19_Vaccine_BeijingOrganism.h"

@implementation AbstractFactory_Beijing

- (id<COVID_19_VaccineProtocol>)vaccine{
    return [COVID_19_Vaccine_BeijingOrganism new];
}

- (NSString *)brandName{
    return @"北京生物";
}

@end
