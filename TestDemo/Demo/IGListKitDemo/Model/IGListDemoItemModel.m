//
// IGListDemoItemModel.m
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
    

#import "IGListDemoItemModel.h"

@implementation IGListDemoItemModel

- (instancetype)initWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier {
    self = [super init];
    if (self) {
        _name = [name copy];
        _controllerClass = [controllerClass copy];
        _controllerIdentifier = [controllerIdentifier copy];
    }
    return self;
}

+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass controllerIdentifier:(NSString *)controllerIdentifier {
    return [[self alloc] initWithName:name controllerClass:controllerClass controllerIdentifier:controllerIdentifier];
}

+ (instancetype)DemoItemWithName:(NSString *)name controllerClass:(Class)controllerClass {
    return [[self alloc] initWithName:name controllerClass:controllerClass controllerIdentifier:nil];
}

- (id<NSObject>)diffIdentifier {
    return _name;
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if ([self isEqual:object]) {
        return YES;
    }

    if ([(NSObject *)object isKindOfClass:[IGListDemoItemModel class]]) {
        IGListDemoItemModel *oobject = (IGListDemoItemModel *)object;
        return _controllerClass == oobject.controllerClass && [_controllerIdentifier isEqualToString:oobject.controllerIdentifier];
    } else {
        return NO;
    }
}


@end
