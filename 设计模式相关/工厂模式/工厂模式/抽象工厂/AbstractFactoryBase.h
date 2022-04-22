//
//  AbstractFactoryBase.h
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import "COVID_19_VaccineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractFactoryBase : NSObject

+ (AbstractFactoryBase *)factory;

- (id<COVID_19_VaccineProtocol>)vaccine;
//暂时想不到生产啥 就返回一个字符串先
//生产疫苗的品牌~ 北京生物 兰州生物 其实都是同一个方子 只是在不同的地方生产 叫法不同
- (NSString *)brandName;

@end

NS_ASSUME_NONNULL_END
