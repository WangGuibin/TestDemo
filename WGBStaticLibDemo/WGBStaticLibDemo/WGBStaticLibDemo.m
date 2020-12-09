//
//  WGBStaticLibDemo.m
//  WGBStaticLibDemo
//
//  Created by mac on 2020/12/9.
//

#import "WGBStaticLibDemo.h"

@implementation WGBStaticLibDemo

- (void)helloWorld{
    NSLog(@"世界,你好");
}
- (void)sayHelloWithName:(NSString *)name{
    NSLog(@"%@,你好",name);
}

+ (void)helloWorld{
    NSLog(@"世界,你好");
}
+ (void)sayHelloWithName:(NSString *)name{
    NSLog(@"%@,你好",name);
}

- (void)helloWorldWithCallBack:(dispatch_block_t)callBack{
    [self helloWorld];
    !callBack? : callBack();
}

- (void)sayHelloWithText:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
    // 1. 首先创建多参数列表
    va_list args;
    // 2. 开始初始化参数, start会从format中 依次提取参数, 类似于类结构体中的偏移量 offset 的 方式
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    
    // 3. end 必须添加, 具体可参考 👇
    //  http://www.cppblog.com/ownwaterloo/archive/2009/04/21/is_va_end_necessary.html 此链接
    va_end(args);
    NSLog(@"%@,你好",str);
}

- (NSString *)getText{
    return @"WGBStaticLibDemo 代码天下第一";
}
+ (NSString *)getText{
    return @"WGBStaticLibDemo 代码天下第一";
}

@end
