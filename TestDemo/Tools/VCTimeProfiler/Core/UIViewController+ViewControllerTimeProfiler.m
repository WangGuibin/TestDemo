//
//  UIViewController+ViewControllerTimeProfiler.m
//  VCTimeProfiler
//
//  Created by Su XinDe on 2018/7/17.
//

#import "UIViewController+ViewControllerTimeProfiler.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <sys/time.h>
#import "VCTimeProfilerRecorder.h"


#define VCP_LOG_ENABLE 0
#if VCP_LOG_ENABLE
#define VCLog(...) NSLog(__VA_ARGS__)
#else
#define VCLog(...)
#endif

static char const kAssociatedRemoverKey;
static NSString *const kUniqueFakeKeyPath = @"sp_useless_key_path";

#pragma mark - IMP of Key Method

static void sp_loadView(UIViewController *kvo_self, SEL _sel) {
    Class kvo_cls = object_getClass(kvo_self);
    Class origin_cls = class_getSuperclass(kvo_cls);
    IMP origin_imp = method_getImplementation(class_getInstanceMethod(origin_cls, _sel));
    assert(origin_imp != NULL);

    void (*func)(UIViewController *, SEL) = (void (*)(UIViewController *, SEL))origin_imp;

    struct timeval now;
    gettimeofday(&now, NULL);
    NSTimeInterval nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -loadView \t\tbegin  at CF time:\t%lf", kvo_self, nowTimeInterval);
    
    [[VCTimeProfilerRecorder shared] recordVCLoadTimeConsume:kvo_self
                                                lifeCycleState:VCLifeCycleStateLoadView
                                                     timePoint:nowTimeInterval];
    
    func(kvo_self, _sel);
    
    gettimeofday(&now, NULL);
    nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -loadView \t\tfinish at CF time:\t%lf", kvo_self, nowTimeInterval);
}

static void sp_viewDidLoad(UIViewController *kvo_self, SEL _sel) {
    Class kvo_cls = object_getClass(kvo_self);
    Class origin_cls = class_getSuperclass(kvo_cls);
    IMP origin_imp = method_getImplementation(class_getInstanceMethod(origin_cls, _sel));
    assert(origin_imp != NULL);

    void (*func)(UIViewController *, SEL) = (void (*)(UIViewController *, SEL))origin_imp;

    struct timeval now;
    gettimeofday(&now, NULL);
    NSTimeInterval nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewDidLoad \t\tbegin  at CF time:\t%lf", kvo_self, nowTimeInterval);
    
    [[VCTimeProfilerRecorder shared] recordVCLoadTimeConsume:kvo_self
                                                lifeCycleState:VCLifeCycleStateViewDidLoad
                                                     timePoint:nowTimeInterval];
    
    func(kvo_self, _sel);
    
    gettimeofday(&now, NULL);
    nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewDidLoad \t\tfinish at CF time:\t%lf", kvo_self, nowTimeInterval);
}

static void sp_viewWillAppear(UIViewController *kvo_self, SEL _sel, BOOL animated) {
    Class kvo_cls = object_getClass(kvo_self);
    Class origin_cls = class_getSuperclass(kvo_cls);

    IMP origin_imp = method_getImplementation(class_getInstanceMethod(origin_cls, _sel));
    assert(origin_imp != NULL);

    void (*func)(UIViewController *, SEL, BOOL) = (void (*)(UIViewController *, SEL, BOOL))origin_imp;

    struct timeval now;
    gettimeofday(&now, NULL);
    NSTimeInterval nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewWillAppear \tbegin  at CF time:\t%lf", kvo_self, nowTimeInterval);
    
    [[VCTimeProfilerRecorder shared] recordVCLoadTimeConsume:kvo_self
                                                lifeCycleState:VCLifeCycleStateViewWillAppear
                                                     timePoint:nowTimeInterval];
    
    func(kvo_self, _sel, animated);
    
    gettimeofday(&now, NULL);
    nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewWillAppear \tfinish at CF time:\t%lf", kvo_self, nowTimeInterval);
}

static void sp_viewDidAppear(UIViewController *kvo_self, SEL _sel, BOOL animated) {
    Class kvo_cls = object_getClass(kvo_self);
    Class origin_cls = class_getSuperclass(kvo_cls);
    IMP origin_imp = method_getImplementation(class_getInstanceMethod(origin_cls, _sel));
    assert(origin_imp != NULL);

    void (*func)(UIViewController *, SEL, BOOL) = (void (*)(UIViewController *, SEL, BOOL))origin_imp;

    struct timeval now;
    gettimeofday(&now, NULL);
    NSTimeInterval nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewDidAppear \tbegin  at CF time:\t%lf", kvo_self, nowTimeInterval);
    
    [[VCTimeProfilerRecorder shared] recordVCLoadTimeConsume:kvo_self
                                                lifeCycleState:VCLifeCycleStateViewDidAppear
                                                     timePoint:nowTimeInterval];
    
    func(kvo_self, _sel, animated);
    
    gettimeofday(&now, NULL);
    nowTimeInterval = now.tv_sec + now.tv_usec * 1e-6;
    VCLog(@"VC: %p -viewDidAppear \tfinish at CF time:\t%lf", kvo_self, nowTimeInterval);
}

@implementation VCTimeProfilerKVOObserver

+ (instancetype)shared {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end

@implementation VCTimeProfilerKVORemover

- (void)dealloc {
    //    VCLog(@"dealloc: %@", _target);
    @try {
        [_target removeObserver:[VCTimeProfilerKVOObserver shared]
                     forKeyPath:_keyPath];
    } @catch(NSException *e) {
        VCLog(@"%s: %@", __func__, e);
    }
    _target = nil;
}

@end


@implementation UIViewController (ViewControllerTimeProfiler)

+ (void)load {
    [self bindViewControllerTimeProfiler];
}

+ (void)bindViewControllerTimeProfiler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [UIViewController class];
        [self swizzleMethodInClass:class
                    originalMethod:@selector(initWithNibName:bundle:)
                  swizzledSelector:@selector(sp_initWithNibName:bundle:)];
        [self swizzleMethodInClass:class
                    originalMethod:@selector(initWithCoder:)
                  swizzledSelector:@selector(sp_initWithCoder:)];
    });
}

- (instancetype)sp_initWithNibName:(nullable NSString *)nibNameOrNil
                               bundle:(nullable NSBundle *)nibBundleOrNil {
    [self createAndHookKVOClass];
    [self sp_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (nullable instancetype)sp_initWithCoder:(NSCoder *)aDecoder {
    [self createAndHookKVOClass];
    [self sp_initWithCoder:aDecoder];
    return self;
}

- (void)createAndHookKVOClass {
    // Setup KVO, which trigger runtime to create the KVO subclass of VC.
    [self addObserver:[VCTimeProfilerKVOObserver shared]
           forKeyPath:kUniqueFakeKeyPath
              options:NSKeyValueObservingOptionNew
              context:nil];

    // Setup remover of KVO, automatically remove KVO when VC dealloc.
    VCTimeProfilerKVORemover *remover = [[VCTimeProfilerKVORemover alloc] init];
    remover.target = self;
    remover.keyPath = kUniqueFakeKeyPath;
    objc_setAssociatedObject(self,
                             &kAssociatedRemoverKey,
                             remover,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // NSKVONotifying_ViewController
    Class kvoCls = object_getClass(self);

    // Compare current Imp with our Imp. Make sure we didn't hooked before.
    IMP currentViewDidLoadImp = class_getMethodImplementation(kvoCls,
                                                              @selector(viewDidLoad));
    if (currentViewDidLoadImp == (IMP)sp_viewDidLoad) {
        return;
    }

    // ViewController
    Class originCls = class_getSuperclass(kvoCls);

    //VCLog(@"Hook %@", kvoCls);

    // 获取原来实现的encoding
    const char *originLoadViewEncoding =
    method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(loadView)));
    
    const char *originViewDidLoadEncoding =
    method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewDidLoad)));
    const char *originViewDidAppearEncoding = method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewDidAppear:)));
    const char *originViewWillAppearEncoding = method_getTypeEncoding(class_getInstanceMethod(originCls, @selector(viewWillAppear:)));

    // 重点，添加方法。
    class_addMethod(kvoCls, @selector(loadView), (IMP)sp_loadView, originLoadViewEncoding);
    class_addMethod(kvoCls, @selector(viewDidLoad), (IMP)sp_viewDidLoad, originViewDidLoadEncoding);
    class_addMethod(kvoCls, @selector(viewDidAppear:), (IMP)sp_viewDidAppear, originViewDidAppearEncoding);
    class_addMethod(kvoCls, @selector(viewWillAppear:), (IMP)sp_viewWillAppear, originViewWillAppearEncoding);
}

+ (void)swizzleMethodInClass:(Class)
class originalMethod:(SEL)originalSelector
            swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
