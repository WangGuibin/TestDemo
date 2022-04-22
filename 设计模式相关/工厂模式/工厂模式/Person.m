//
//  Person.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "Person.h"

@implementation Person

- (void)injectionCOVID_19_Vaccine:(id<COVID_19_VaccineProtocol>)vaccine{
    NSLog(@"%@ 注射💉了 -  %@ 新冠疫苗",self.name,vaccine.vaccineName);
}


@end
