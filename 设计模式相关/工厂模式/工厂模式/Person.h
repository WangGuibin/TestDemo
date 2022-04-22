//
//  Person.h
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import "COVID_19_VaccineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSUInteger age;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *cardID;

- (void)injectionCOVID_19_Vaccine:(id<COVID_19_VaccineProtocol>)vaccine;

@end

NS_ASSUME_NONNULL_END
