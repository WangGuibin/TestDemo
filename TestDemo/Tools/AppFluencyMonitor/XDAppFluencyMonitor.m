//
//  XDAppFluencyMonitor.m
//  XDAppFluencyMonitorDemo
//
//  Created by suxinde on 16/8/5.
//  Copyright © 2016年 com.su. All rights reserved.
//

#import "XDAppFluencyMonitor.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#import "XDMachThreadBacktrace.h"

/* 
 参考：
 Printing a stack trace from another thread
 http://stackoverflow.com/questions/4765158/printing-a-stack-trace-from-another-thread
 
 What you do is:
 
 1. Make a new machine context structure (_STRUCT_MCONTEXT)
 2. Fill in its stack state using thread_get_state()
 3. Get the program counter (first stack trace entry) and frame pointer (all the rest)
 Step through the stack frame pointed to by the frame pointer and store all instruction addresses in a buffer for later use.
 
 4. Note that you should pause the thread before doing this or else you can get unpredictable results.
    The stack frame is filled with structures containing two pointers:
    (1) Pointer to the next level up on the stack
    (2) Instruction address
 
 So you need to take that into account when walking the frame to fill out your stack trace. There's also the possibility of a corrupted stack, leading to a bad pointer, which will crash your program. You can get around this by copying memory using vm_read_overwrite(), which first asks the kernel if it has access to the memory, so it doesn't crash.
 
 Once you have the stack trace, you can just call backtrace() on it like normal (The crash handler has to be async-safe so it implements its own backtrace method, but in normal cases backtrace() is fine).
 
*/


static NSString *const kMTAppFluencyLogFilesDirectory = @"XDAppFluencyLogFilesDirectory";

dispatch_queue_t xd_fluency_monitor_queue() {
    static dispatch_queue_t xd_fluency_monitor_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xd_fluency_monitor_queue = dispatch_queue_create("com.su.diary.xd_fluency_monitor_queue", NULL);
    });
    return xd_fluency_monitor_queue;
}

dispatch_queue_t xd_fluency_monitor_logs_queue() {
    static dispatch_queue_t xd_fluency_monitor_logs_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xd_fluency_monitor_logs_queue = dispatch_queue_create("com.su.diary.xd_fluency_monitor_logs_queue", NULL);
    });
    return xd_fluency_monitor_logs_queue;
}

@interface XDAppFluencyLogsFileManager : NSObject

+ (NSString *)logsDirectory;

+ (NSString *)timeStamp;

+ (NSString *)logFileName;

+ (void)writeLogsToLogDirectory:(NSString *)logs;

@end

@implementation XDAppFluencyLogsFileManager

+ (NSString *)timeStamp
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone localTimeZone];
    df.dateFormat = @"YYYY-MM-dd HH:mm:ss:SSS";
    NSString *timeStamp = [df stringFromDate:curDate];
    return timeStamp;
}

+ (NSString *)logFileName
{
    NSString *logFileName = [NSString stringWithFormat:@"%@_%@.txt", [NSUUID UUID].UUIDString,@([NSDate date].timeIntervalSince1970).stringValue];
    return logFileName;
}

/**
 *  log存放文件夹
 */
+ (NSString *)logsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *logsDirectory = [documentsDirectory stringByAppendingPathComponent:kMTAppFluencyLogFilesDirectory];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    // 该用户的目录是否存在，若不存在则创建相应的目录
    BOOL isDirectory = NO;
    BOOL isExisting = [fileManager fileExistsAtPath:logsDirectory isDirectory:&isDirectory];
    
    if (!(isExisting && isDirectory)) {
        BOOL createDirectory = [fileManager createDirectoryAtPath:logsDirectory
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirectory) {
            NSLog(@"卡顿监听Log文件目录创建失败");
        }
    }
    
    return logsDirectory;
    
}

+ (void)writeLogsToLogDirectory:(NSString *)logs
{
    dispatch_async(xd_fluency_monitor_logs_queue(), ^{
        NSData *logsData = [logs dataUsingEncoding:NSUTF8StringEncoding];
        if (logsData) {
            NSString *logFileName = [XDAppFluencyLogsFileManager logFileName];
            NSString *filePath = [[XDAppFluencyLogsFileManager logsDirectory] stringByAppendingPathComponent:logFileName];
            BOOL reslut = [logsData writeToFile:filePath atomically:YES];
            if (reslut != YES) {
                NSLog(@"%s: 保存App卡顿日志文件失败", __FUNCTION__);
            }
        }
 
    });
}

@end


@interface XDAppFluencyMonitor () {
@private
    NSInteger _timeoutCount;
    CFRunLoopObserverRef _runLoopObserver;
}

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) CFRunLoopActivity runLoopActivity;

@end

@implementation XDAppFluencyMonitor

static void runLoopObserverCallBack(CFRunLoopObserverRef observer,
                                    CFRunLoopActivity activity,
                                    void* info)
{
    XDAppFluencyMonitor *appFluencyMonitor = (__bridge XDAppFluencyMonitor*)info;
    appFluencyMonitor.runLoopActivity = activity;
    dispatch_semaphore_signal(appFluencyMonitor.semaphore);
}



- (void)dealloc
{
    [self stopMonitoring];
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.logsEnabled = YES;
}

#pragma mark - Public Methods

+ (instancetype)sharedInstance
{
    static id __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[[self class] alloc] init];
    });
    return __sharedInstance;
}

- (void)stopMonitoring
{
    if (!_runLoopObserver)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(_runLoopObserver);
    _runLoopObserver = NULL;
}


- (void)startMonitoring
{
    // 已经有runloopObserver在监听时直接返回，不重复创建runloopObserver监听
    if (_runLoopObserver) {
        return;
    }
    
    //  创建信号量
    self.semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop的状态监听
    /*
    typedef struct {
        CFIndex	version;
        void *	info;
        const void *(*retain)(const void *info);
        void	(*release)(const void *info);
        CFStringRef	(*copyDescription)(const void *info);
    } CFRunLoopObserverContext;
    */
    CFRunLoopObserverContext context = {
        0,
        (__bridge void*)self,
        NULL,
        NULL
    };
    
    _runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                               kCFRunLoopAllActivities,
                                               YES,
                                               0,
                                               &runLoopObserverCallBack,
                                               &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(),
                         _runLoopObserver,
                         kCFRunLoopCommonModes);
    
    // 在子线程监控时长
    dispatch_async(xd_fluency_monitor_queue(), ^{
        while (YES)
        {
            // 假定连续5次超时100ms认为卡顿(也包含了单次超时500ms)
            long st = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 500*NSEC_PER_MSEC));
            if (st != 0) {
                if (!_runLoopObserver) {
                    _timeoutCount = 0;
                    self.semaphore = 0;
                    self.runLoopActivity = 0;
                    return;
                }
                
                if (self.runLoopActivity == kCFRunLoopBeforeSources ||
                    self.runLoopActivity == kCFRunLoopAfterWaiting)
                {
                    if (++_timeoutCount < 5)
                        continue;
                    
                    [self handleCallbacksStackForMainThreadStucked];
                    
                }
            }
             _timeoutCount = 0;
        }
    });
    
}


#pragma mark - Private Methods

- (void)handleCallbacksStackForMainThreadStucked
{
    NSString *backtraceLogs = [self formatBacktraceLogsForAllThreads];
    
    [XDAppFluencyLogsFileManager writeLogsToLogDirectory:backtraceLogs];
}

- (NSString * _Nonnull)formatBacktraceForThread:(thread_t)thread {
    
    int const maxStackDepth = 128;
    
    void **backtraceStack = calloc(maxStackDepth, sizeof(void *));
    int backtraceCount = sxd_backtraceForMachThread(thread, backtraceStack, maxStackDepth);
    char **backtraceStackSymbols = backtrace_symbols(backtraceStack, backtraceCount);

    NSMutableString *stackTrace = [NSMutableString string];
    for (int i = 0; i < backtraceCount; ++i) {
        char *currentStackInfo = backtraceStackSymbols[i];
        [stackTrace appendString:[NSString stringWithUTF8String:currentStackInfo]];
        [stackTrace appendFormat:@"\n"];
    }
    return stackTrace;
}

- (NSString *)formatBacktraceLogsForAllThreads
{
    // 1. 获取所有线程
    mach_msg_type_number_t threadCount;
    thread_act_array_t threadList;
    kern_return_t kret;
    
    kret = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kret != KERN_SUCCESS) {
        if (self.logsEnabled) {
            NSLog(@"获取线程列表失败: %s\n", mach_error_string(kret));
        }
        // 获取线程列表失败，运行中的线程的调用栈将不精确，没有收集的必要，直接返回空
        return nil;
    }

    // 2. 挂起所有线程，保证call stack信息的精确性
    thread_t selfThread = mach_thread_self();
    for (int i = 0; i < threadCount; ++i) {
        if (threadList[i] != selfThread) {
            thread_suspend(threadList[i]);
        }
    }

    // 3. 获取所有线程的backtrace信息
    NSMutableArray *backTracesArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < threadCount; ++i) {
        thread_t tmpThread = threadList[i];
        NSString *backTrace = [self formatBacktraceForThread:tmpThread];
        if (backTrace) {
            [backTracesArray addObject:backTrace];
        }
    }
    
    // 4. 激活被挂起的线程
    for (int i = 0; i < threadCount; ++i) {
        thread_resume(threadList[i]);
    }

    // 5. 格式化输出backtrace log信息,写入日记文件
    NSMutableString *logs = nil;
    if (backTracesArray.count) {
        
        NSString *timeStamp = [XDAppFluencyLogsFileManager timeStamp];
        
        logs = [[NSMutableString alloc] initWithCapacity:0];
        
        [logs appendFormat:@"\n**************************************\n"];
        [logs appendFormat:@"Time: %@\n", timeStamp];
        UIDevice *device = [UIDevice currentDevice];
        [logs appendFormat:@"Device: %@ systemVersion: %@\n\n",device.name, device.systemVersion];
        for(NSInteger idx = 0; idx < backTracesArray.count; idx++) {
            [logs appendFormat:@"%@", backTracesArray[idx]];
            [logs appendFormat:@"\n\n\n"];
        }
        [logs appendFormat:@"\n**************************************\n\n\n"];
    }
    
    
    if (self.logsEnabled) {
        NSLog(@"%@", logs);
    }
    
    return logs;
}



@end


