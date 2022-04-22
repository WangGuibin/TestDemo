//
//  COVID-19_VaccineBaseObject.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "COVID-19_VaccineBaseObject.h"

@implementation COVID_19_VaccineBaseObject

//疫苗名
- (NSString *)vaccineName{
    //子类去实现
    return nil;
}

//有效期
- (void)validDate{
    //子类去实现
}
//打几次
- (void)inputTimes{
    //子类去实现
}

//限制条件
- (void)limitConditions{
    NSLog(@"打完疫苗 48小时内不能做核酸");
}


@end
