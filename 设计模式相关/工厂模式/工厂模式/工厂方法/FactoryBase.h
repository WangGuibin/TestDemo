//
//  FactoryBase.h
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import "COVID_19_VaccineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FactoryBase : NSObject


- (id<COVID_19_VaccineProtocol>)createVaccine;

@end

NS_ASSUME_NONNULL_END
