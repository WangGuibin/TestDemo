//
//  XDMachThreadBacktrace.h
//  XDAppFluencyMonitor
//
//  Created by suxinde on 16/8/9.
//  Copyright © 2016年 com.su. All rights reserved.
//

#ifndef XDMachThreadBacktrace_h
#define XDMachThreadBacktrace_h

#include <stdio.h>

#include <mach/mach.h>

/**
 *  fill a backtrace call stack array of given thread
 *
 *  @param thread   mach thread for tracing
 *  @param stack    caller space for saving stack trace info
 *  @param maxCount max stack array count
 *
 *  @return call stack address array
 */
int sxd_backtraceForMachThread(thread_t thread, void** stack, int maxCount);


#endif /* XDMachThreadBacktrace_h */
