//
//  COVID_19_Vaccine_BeijingOrganism.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "COVID_19_Vaccine_BeijingOrganism.h"

@implementation COVID_19_Vaccine_BeijingOrganism

//疫苗名
- (NSString *)vaccineName{
    NSLog(@"北京生物");
    return @"北京生物";
}

//有效期
- (void)validDate{
    NSLog(@"半年打一次");
}
//打几次
- (void)inputTimes{
    NSLog(@"打三次 两剂次+一剂加强针");
}

@end
