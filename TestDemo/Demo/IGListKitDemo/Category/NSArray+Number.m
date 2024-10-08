
//
// NSArray+Number.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/12
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
    

#import "NSArray+Number.h"


@implementation NSArray (Number)

+ (instancetype)arrayWithNumber:(NSNumber *)number {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [number integerValue]; i++) {
        [array addObject:[NSNumber numberWithInteger:i]];
    }
    
    return [array copy];
}

+ (instancetype)arrayWithFrom:(NSUInteger)from to:(NSUInteger)to {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = from; i < to; i++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    return [array copy];
}

@end
