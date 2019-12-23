//
// HttpProxy.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/23
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "HttpProxy.h"
#import <objc/runtime.h>

@interface HttpProxy ()
@property(strong, nonatomic) NSMutableDictionary *selToHandlerMap;
@end

@implementation HttpProxy

#pragma mark - Public methods

+ (instancetype)sharedInstance {
    static HttpProxy *httpProxy = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpProxy = [HttpProxy alloc];
        httpProxy.selToHandlerMap = [NSMutableDictionary new];
    });

    return httpProxy;
}

- (void)registerHttpProtocol:(Protocol *)httpProtocol handler:(id)handler {
    unsigned int numberOfMethods = 0;

    //Get all methods in protocol
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(
            httpProtocol, YES, YES, &numberOfMethods);

    //Register protocol methods
    for (unsigned int i = 0; i < numberOfMethods; i++) {
        struct objc_method_description method = methods[i];
        [_selToHandlerMap setValue:handler forKey:NSStringFromSelector(method.name)];
    }
}

#pragma mark - Methods route

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSString *methodsName = NSStringFromSelector(sel);
    id handler = [_selToHandlerMap valueForKey:methodsName];

    if (handler != nil && [handler respondsToSelector:sel]) {
        return [handler methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *methodsName = NSStringFromSelector(invocation.selector);
    id handler = [_selToHandlerMap valueForKey:methodsName];

    if (handler != nil && [handler respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:handler];
    } else {
        [super forwardInvocation:invocation];
    }
}

@end
