//
//  Factory_Beijing.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "Factory_Beijing.h"
#import "COVID_19_Vaccine_BeijingOrganism.h"

@implementation Factory_Beijing

- (id<COVID_19_VaccineProtocol>)createVaccine{
    return [COVID_19_Vaccine_BeijingOrganism new];
}

@end
