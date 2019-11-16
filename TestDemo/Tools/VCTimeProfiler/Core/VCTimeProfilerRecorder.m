//
//  VCTimeProfilerRecorder.m
//  VCTimeProfiler
//
//  Created by Su XinDe on 2018/8/2.
//

#import "VCTimeProfilerRecorder.h"
#import <sys/time.h>

@implementation VCTimeProfilerRecord

- (instancetype)init {
    if (self = [super init]) {
        [self privateInit];
    }
    return self;
}

- (void)privateInit {
    struct timeval now;
    gettimeofday(&now, NULL);
    NSTimeInterval nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    self.recordCreateTimePoint = nowTimeInterval;
}

- (NSTimeInterval)loadVCTimeCostInMS {
    if (self.viewDidAppearTimePoint == 0.f) {
        return 0.f;
    }

    if (self.loadViewTimePoint) {
        return (self.viewDidAppearTimePoint - self.loadViewTimePoint) * 1000.f;
    } else if (self.viewDidLoadTimePoint) {
        return (self.viewDidAppearTimePoint - self.viewDidLoadTimePoint) * 1000.f;
    } else {
        return 0.f;
    }
}

- (NSString *)description {
    NSString *des = [NSString stringWithFormat:@"[%@]<%@> load cost time: %.3lf ms",
                     self.className, self.instancePtr, [self loadVCTimeCostInMS]];
    return des;
}

@end


@interface VCTimeProfilerRecorder ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, VCTimeProfilerRecord *> *cache;

@property (nonatomic, strong, readwrite) NSArray<VCTimeProfilerRecord *> *records;

@property (nonatomic, strong) dispatch_queue_t recordQueue;

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation VCTimeProfilerRecorder


+ (instancetype)shared {
    static id __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self privateInit];
    }
    return self;
}


- (void)start {
    self.isRunning = YES;
}

- (void)stop {
    self.isRunning = NO;
}


- (void)privateInit {
    self.recordQueue = dispatch_queue_create("com.su.SP.VCTimerProfilerRecorderQueue",
                                             DISPATCH_QUEUE_SERIAL);
    self.cache = [NSMutableDictionary dictionary];
}

- (void)recordVCLoadTimeConsume:(UIViewController *)vc
                 lifeCycleState:(VCLifeCycleState)lifeCycleState
                      timePoint:(NSTimeInterval)timePoint {
    
    if (!self.isRunning) {
        return;
    }
    
    // 过滤掉默认系统UI类
    NSString *className = NSStringFromClass([vc class]);
    if ([className hasPrefix:@"UI"]) {
        return;
    }
    
    // 过滤掉特定的VC类
    if (![vc isKindOfClass:[UIViewController class]] ||
        [vc isKindOfClass:[UINavigationController class]] ||
        [vc isKindOfClass:[UITabBarController class]] ||
        [vc isKindOfClass:[UIAlertController class]]) {
        return;
    }
    
    // 过滤掉组件的VC类
//    if ([vc isViewLoaded] && [className hasPrefix:@"SP"]) {
//        return;
//    }
    
    
    dispatch_async(self.recordQueue, ^{
        
        // 过滤不需要的信息
        if (lifeCycleState != VCLifeCycleStateLoadView &&
            lifeCycleState != VCLifeCycleStateViewDidLoad &&
            lifeCycleState != VCLifeCycleStateViewDidAppear) {
            return;
        }
        
        NSString *vcPtr = [NSString stringWithFormat:@"%p", vc];
        VCTimeProfilerRecord *record = self.cache[vcPtr];
        if (!record) {
            record = [VCTimeProfilerRecord new];
            self.cache[vcPtr] = record;
        }
        record.instancePtr = vcPtr;
        record.className = className;
        if (lifeCycleState == VCLifeCycleStateLoadView) {
            record.loadViewTimePoint = timePoint;
        } else if (lifeCycleState == VCLifeCycleStateViewDidLoad) {
            record.viewDidLoadTimePoint = timePoint;
        } else if (lifeCycleState == VCLifeCycleStateViewDidAppear) {
            record.viewDidAppearTimePoint = timePoint;
            
            // 拷贝处理，保证多线程访问安全
            NSMutableArray *tmp = self.records ? [self.records mutableCopy] : @[].mutableCopy;
            [tmp addObject:record];
            self.records = [tmp copy];
            [self.cache removeObjectForKey:vcPtr];
        }
        
    });
    
    
}


@end
