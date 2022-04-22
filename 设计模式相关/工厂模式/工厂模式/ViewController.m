//
//  ViewController.m
//  工厂模式
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/21.
//

#import "ViewController.h"
#import "COVID_19_VaccineManager.h"
#import "Person.h"

#import "Factory_Beijing.h"
#import "Factory_KeXing.h"


#import "AbstractFactoryBase.h"
#import "AbstractFactory_Beijing.h"
#import "AbstractFactory_LanZhou.h"


@interface ViewController ()

@end

@implementation ViewController

/**
 优点
 
 客户端可以直接消费产品，而不必关心具体产品的实现，消除了客户端直接创建产品对象的责任，实现了对责任的分割。
 简单点说就是客户端调用简单明了，不需要关注太多的逻辑。
 
 缺点
 
 工厂类集中了所有产品的创建逻辑，一旦不能正常工作，整个系统都会受到影响，而且当产品类别多结构复杂的时候，把所有创建工作放进一个工厂来，会使后期程序的扩展较为困难。产品类本身是符合开闭原则的，对扩展开放对修改关闭，但是工厂类却违反了开闭原则，因为每增加一个产品，工厂类都需要进行逻辑修改和判断，导致耦合度太高。例如增加一个BananaFruit，在工厂类FruitFactory就要新增加一个枚举FruitTypeBanana。
 
 开闭原则
 
 一个软件实体(如类、模块、函数)应当对扩展开放，对修改关闭。
 开放-封闭原则的思想就是设计的时候，尽量让设计的类做好后就不再修改，如果有新的需求，通过新加类的方式来满足，而不去修改现有的类(代码)。

 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 简单工厂 -> 违背开闭原则  工厂类的职责太重了
    id<COVID_19_VaccineProtocol> beijing = [COVID_19_VaccineManager injectionCOVID_19_VaccineWithType:(COVID_19_VaccineType_BeijingOrg)];
    [COVID_19_VaccineManager printInfo:beijing];
    
    id<COVID_19_VaccineProtocol> kexing = [COVID_19_VaccineManager injectionCOVID_19_VaccineWithType:(COVID_19_VaccineType_KeXing)];
    [COVID_19_VaccineManager printInfo:kexing];
    
    
    Person *p1 = [Person new];
    p1.name = @"小明";
    p1.age = 18;
    p1.sex = @"男";
    p1.cardID = @"01";
    [p1 injectionCOVID_19_Vaccine:beijing];

    Person *p2 = [Person new];
    p2.name = @"小敏";
    p2.age = 18;
    p2.sex = @"女";
    p2.cardID = @"02";
    [p2 injectionCOVID_19_Vaccine:kexing];
    
    //工厂方法 在简单工厂模式的基础上 对工厂进行子类化创建
    // 一个工厂对应创建一种疫苗实例
    // 优点是符合开闭原则 缺点就是略显啰嗦
    
    //北京的工厂生产北京生物
    FactoryBase *beijing_factory = [Factory_Beijing new];
    beijing = [beijing_factory createVaccine];
    [p1 injectionCOVID_19_Vaccine:beijing];
    [p2 injectionCOVID_19_Vaccine:beijing];

    //科兴的工厂生产科兴
    FactoryBase *kexing_factory = [Factory_KeXing new];
    kexing = [kexing_factory createVaccine];
    [p1 injectionCOVID_19_Vaccine:kexing];
    [p2 injectionCOVID_19_Vaccine:kexing];
    
    
    //抽象工厂
    AbstractFactoryBase *beijing_sw = [AbstractFactory_Beijing factory];
    beijing = [beijing_sw vaccine];
    [p1 injectionCOVID_19_Vaccine:beijing];
    [p2 injectionCOVID_19_Vaccine:beijing];
    NSLog(@"这是抽象工厂创建的: %@",[beijing_sw brandName]);
    
    AbstractFactoryBase *lanzhou_sw = [AbstractFactory_LanZhou factory];
    id<COVID_19_VaccineProtocol> lanzhou  = [beijing_sw vaccine];
    [p1 injectionCOVID_19_Vaccine:lanzhou];
    [p2 injectionCOVID_19_Vaccine:lanzhou];
    NSLog(@"这是抽象工厂创建的: %@",[lanzhou_sw brandName]);

}


@end
