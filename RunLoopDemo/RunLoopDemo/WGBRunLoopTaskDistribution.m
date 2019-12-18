//
//  WGBRunLoopTaskDistribution.m
//  RunLoopDemo
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBRunLoopTaskDistribution.h"
#import <objc/runtime.h>

@interface WGBRunLoopTaskDistribution()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSMutableArray *tasksKeys;
@property (nonatomic,strong) CADisplayLink *timeLink;

@end

@implementation WGBRunLoopTaskDistribution

- (void)removeAllTasks {
    [self.tasks removeAllObjects];
    [self.tasksKeys removeAllObjects];
}

- (void)addTask:(WGBRunLoopTaskDistributionUnit)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.maxTaskCount) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

- (void)wgb_doNothingsAction:(CADisplayLink *)timer {
    //We do nothing here
}

- (instancetype)init
{
    if ((self = [super init])) {
        _maxTaskCount = 50;
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
        _timeLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(wgb_doNothingsAction:)];
        [_timeLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

+ (instancetype)sharedRunLoopTaskDistribution {
    static WGBRunLoopTaskDistribution *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[WGBRunLoopTaskDistribution alloc] init];
        [self _registerRunLoopTaskDistributionAsMainRunloopObserver:singleton];
    });
    return singleton;
}

//注册runloop任务
+ (void)_registerRunLoopTaskDistributionAsMainRunloopObserver:(WGBRunLoopTaskDistribution *)runLoopWorkDistribution {
    //添加监听者
    static CFRunLoopObserverRef defaultModeObserver;
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopTaskDistributionCallback);
}

static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback) {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        info,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(     NULL,
                                            activities,
                                            YES,
                                            order,
                                            callback,
                                            &context);
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    WGBRunLoopTaskDistribution *runLoopWorkDistribution = (__bridge WGBRunLoopTaskDistribution *)info;
    if (runLoopWorkDistribution.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
        //轮循执行任务
    while (result == NO && runLoopWorkDistribution.tasks.count) {
        //取出block 执行任务
        WGBRunLoopTaskDistributionUnit unit  = runLoopWorkDistribution.tasks.firstObject;
        result = unit();
        //执行完依次移除
        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
        [runLoopWorkDistribution.tasksKeys removeObjectAtIndex:0];
    }
}

//回调
static void _defaultModeRunLoopTaskDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    _runLoopWorkDistributionCallback(observer, activity, info);
}

@end


@implementation UITableViewCell (WGBRunLoopTaskDistribution)

@dynamic rl_currentIndexPath;

- (void)setRl_currentIndexPath:(NSIndexPath *)rl_currentIndexPath{
    objc_setAssociatedObject(self, @selector(rl_currentIndexPath), rl_currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)rl_currentIndexPath{
    return objc_getAssociatedObject(self, _cmd);
}

@end
