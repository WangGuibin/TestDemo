//
//  WGBStaticLibDemo.h
//  WGBStaticLibDemo
//
//  Created by mac on 2020/12/9.
//

#import <Foundation/Foundation.h>

@interface WGBStaticLibDemo : NSObject

- (void)helloWorld;
- (void)sayHelloWithName:(NSString *)name;

+ (void)helloWorld;
+ (void)sayHelloWithName:(NSString *)name;

- (void)helloWorldWithCallBack:(dispatch_block_t)callBack;
- (void)sayHelloWithText:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (NSString *)getText;
+ (NSString *)getText;

@end
