//
//  AbstractFactoryBase.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "AbstractFactoryBase.h"
#import "AbstractFactory_Beijing.h"
#import "AbstractFactory_LanZhou.h"

@implementation AbstractFactoryBase

+ (AbstractFactoryBase *)factory{
    if ([[self class] isSubclassOfClass:[AbstractFactory_Beijing class]]) {
        return [AbstractFactory_Beijing new];
    }else if ([[self class] isSubclassOfClass:[AbstractFactory_LanZhou class]]){
        return [AbstractFactory_LanZhou new];
    }else{
        return nil;
    }
}

- (id<COVID_19_VaccineProtocol>)vaccine{
    return nil;
}


- (NSString *)brandName{
    return nil;
}

@end
