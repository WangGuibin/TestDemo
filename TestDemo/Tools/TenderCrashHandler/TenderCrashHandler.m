//
//  TenderCrashHandler.m
//  TenderCrashHandlerDemo
//
//  Created by Kitten x iDaily on 17/1/16.
//  Copyright © 2017年 KittenYang. All rights reserved.
//

#import "TenderCrashHandler.h"
#include <sys/signal.h>
#include <execinfo.h>

const NSInteger SkipAddressCount = 4;
const NSInteger ReportAddressCount = 5;

NSString * const TenderCrashHandlerBacktraceKey = @"TenderCrashHandlerBacktraceKey";

NSString * const TenderCrashHandlerSignalKey = @"TenderCrashHandlerSignalKey";
NSString * const TenderCrashHandlerSignalExceptionName = @"TenderCrashHandlerSignalExceptionName";

@implementation TenderCrashHandler

- (void)showCrashAlert:(NSException *)exception {
    __block BOOL shouldRun = YES;
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"App 崩溃了！\n\n"@"%@\n%@", nil),[exception reason],[[exception userInfo] objectForKey:TenderCrashHandlerBacktraceKey]];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"糟糕" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // back to home screen
        UIApplication *app = [UIApplication sharedApplication];
        SEL suspendSelector = NSSelectorFromString(@"suspend");
        if (suspendSelector) [app performSelector:suspendSelector];
#pragma clang diagnostic pop
        //app会挂起
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            shouldRun = NO;
        });
    }]];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:alertVC animated:YES completion:nil];

    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    NSArray *allModes = CFBridgingRelease(CFRunLoopCopyAllModes(runLoop));
    while (shouldRun) {
        for (NSString *mode in allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:TenderCrashHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:TenderCrashHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

@end

NSArray* getbacktrace(void) {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    // ignore the addresses of the signal or exception handling functions
    for (i = SkipAddressCount; i < SkipAddressCount+ReportAddressCount; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

void UncaughtExceptionHandler(NSException *exception) {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:getbacktrace() forKey:TenderCrashHandlerBacktraceKey];
    NSException *new_exception = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    [[[TenderCrashHandler alloc] init] performSelectorOnMainThread:@selector(showCrashAlert:) withObject:new_exception waitUntilDone:YES];
}

void SignalHandler(int signo) {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(signo) forKey:TenderCrashHandlerSignalKey];
    [userInfo setObject:getbacktrace() forKey:TenderCrashHandlerBacktraceKey];
    NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil),signo];
    NSException *new_exception = [NSException exceptionWithName:TenderCrashHandlerSignalExceptionName reason:reason userInfo:userInfo];
    [[[TenderCrashHandler alloc] init] performSelectorOnMainThread:@selector(showCrashAlert:) withObject:new_exception waitUntilDone:YES];
}

void RegisterTenderCrashHandler() {
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
