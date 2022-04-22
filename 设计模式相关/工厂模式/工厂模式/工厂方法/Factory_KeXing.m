//
//  Factory_KeXing.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "Factory_KeXing.h"
#import "COVID_19_Vaccine_KeXing.h"

@implementation Factory_KeXing

- (id<COVID_19_VaccineProtocol>)createVaccine{
    return [COVID_19_Vaccine_KeXing new];
}

@end
