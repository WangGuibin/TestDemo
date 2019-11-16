//
//  XDZombieDetector.m
//  XDDebugToolKitDev
//
//  Created by SuXinDe on 2018/6/10.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import "XDZombieDetector.h"
#import "XDZombieProxy.h"
#import <objc/runtime.h>



typedef void (*XDDeallocPointer) (id obj);
static BOOL _enabled = NO;
static NSArray *_rootClasses = nil;
static NSDictionary<id, NSValue *> *_rootClassDeallocImps = nil;


static inline NSMutableSet *XDZombieDetectorGetIgonreClasses() {
    static NSMutableSet *lxd_sniff_white_list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lxd_sniff_white_list = [[NSMutableSet alloc] init];
    });
    return lxd_sniff_white_list;
}

static inline void __lxd_dealloc(__unsafe_unretained id obj) {
    Class currentCls = [obj class];
    Class rootCls = currentCls;
    
    while (rootCls != [NSObject class] && rootCls != [NSProxy class]) {
        rootCls = class_getSuperclass(rootCls);
    }
    NSString *clsName = NSStringFromClass(rootCls);
    XDDeallocPointer deallocImp = NULL;
    [[_rootClassDeallocImps objectForKey: clsName] getValue: &deallocImp];
    
    if (deallocImp != NULL) {
        deallocImp(obj);
    }
}

static inline IMP XDZombieDetectorSwizzleMethodWithBlock(Method method, void *block) {
    IMP blockImplementation = imp_implementationWithBlock(block);
    return method_setImplementation(method, blockImplementation);
}


@implementation XDZombieDetector


+ (void)initialize {
    _rootClasses = [@[[NSObject class], [NSProxy class]] retain];
}


#pragma mark - Public
+ (void)start {
    @synchronized(self) {
        if (!_enabled) {
            [self _swizzleDealloc];
            _enabled = YES;
        }
    }
}

+ (void)stop {
    @synchronized(self) {
        if (_enabled) {
            [self _unswizzleDealloc];
            _enabled = NO;
        }
    }
}

+ (void)addIgnoreClass:(Class)clazz {
    @synchronized(self) {
        NSMutableSet *whiteList = XDZombieDetectorGetIgonreClasses();
        NSString *clsName = NSStringFromClass(clazz);
        [clsName retain];
        [whiteList addObject: clsName];
    }
}


#pragma mark - Private
+ (void)_swizzleDealloc {
    static void *swizzledDeallocBlock = NULL;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledDeallocBlock = [^void(id obj) {
            Class currentClass = [obj class];
            NSString *clsName = NSStringFromClass(currentClass);
            if ([XDZombieDetectorGetIgonreClasses() containsObject: clsName]) {
                __lxd_dealloc(obj);
            } else {
                NSValue *objVal = [NSValue valueWithBytes: &obj objCType: @encode(typeof(obj))];
                object_setClass(obj, [XDZombieProxy class]);
                ((XDZombieProxy *)obj).originClass = currentClass;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __unsafe_unretained id deallocObj = nil;
                    [objVal getValue: &deallocObj];
                    object_setClass(deallocObj, currentClass);
                    __lxd_dealloc(deallocObj);
                });
            }
        } copy];
    });
    
    NSMutableDictionary *deallocImps = [NSMutableDictionary dictionary];
    for (Class rootClass in _rootClasses) {
        IMP originalDeallocImp = XDZombieDetectorSwizzleMethodWithBlock(class_getInstanceMethod(rootClass, @selector(dealloc)), swizzledDeallocBlock);
        [deallocImps setObject: [NSValue valueWithBytes: &originalDeallocImp objCType: @encode(typeof(IMP))] forKey: NSStringFromClass(rootClass)];
    }
    _rootClassDeallocImps = [deallocImps copy];
}

+ (void)_unswizzleDealloc {
    [_rootClasses enumerateObjectsUsingBlock:^(Class rootClass, NSUInteger idx, BOOL *stop) {
        IMP originalDeallocImp = NULL;
        NSString *clsName = NSStringFromClass(rootClass);
        [[_rootClassDeallocImps objectForKey: clsName] getValue: &originalDeallocImp];
        
        NSParameterAssert(originalDeallocImp);
        method_setImplementation(class_getInstanceMethod(rootClass, @selector(dealloc)), originalDeallocImp);
    }];
    
    [_rootClassDeallocImps release];
    _rootClassDeallocImps = nil;
}


@end

