//
//  COVID_19_VaccineProtocol.h
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol COVID_19_VaccineProtocol <NSObject>

//疫苗名
- (NSString *)vaccineName;
//有效期
- (void)validDate;
//打几次
- (void)inputTimes;
//限制条件
- (void)limitConditions;

@end
NS_ASSUME_NONNULL_END
