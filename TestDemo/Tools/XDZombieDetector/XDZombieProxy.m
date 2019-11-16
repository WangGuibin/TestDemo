//
//  XDZombieProxy.m
//  XDDebugToolKitDev
//
//  Created by SuXinDe on 2018/6/10.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "XDZombieProxy.h"

@implementation XDZombieProxy

- (BOOL)respondsToSelector:(SEL)sel {
    return [self.originClass instancesRespondToSelector:sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.originClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [self _throwMessageSentExceptionWithSelector:invocation.selector];
}

- (void)_throwMessageSentExceptionWithSelector:(SEL)selector {
    NSString *reason = [NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p",
                        NSStringFromClass(self.originClass),
                        NSStringFromSelector(selector),
                        self];
    NSException *exception = [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    @throw exception;
}

#pragma mark -
- (Class)class {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

- (BOOL)isEqual:(id)object {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return NO;
}

- (NSUInteger)hash {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return 0;
}

- (id)self {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

- (BOOL)isKindOfClass:(Class)aClass {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return NO;
}

- (BOOL)isProxy {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return NO;
}

- (id)retain {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

- (oneway void)release {
    [self _throwMessageSentExceptionWithSelector:_cmd];
}

- (id)autorelease {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

- (void)dealloc {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    [super dealloc];
}

- (NSUInteger)retainCount {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return 0;
}


- (NSZone *)zone {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

- (NSString *)description {
    [self _throwMessageSentExceptionWithSelector:_cmd];
    return nil;
}

@end

