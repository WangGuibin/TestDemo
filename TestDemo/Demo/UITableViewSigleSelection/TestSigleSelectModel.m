//
// TestSigleSelectModel.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/8
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
    

#import "TestSigleSelectModel.h"

@implementation TestSigleSelectModel


///MARK:- 构建本地数据
+ (void)craeteLocalDataWithCallBack:(void(^)(NSArray<TestSigleSelectModel*> *modelArray))callBack{
    NSMutableArray *localDataArray = [NSMutableArray array];
    
    TestSigleSelectModel *model0 = [TestSigleSelectModel new];
    model0.name = @"网是卡";
    model0.age = @"1";
    model0.sex = @"男";
    [localDataArray addObject: model0];
    
    TestSigleSelectModel *model1 = [TestSigleSelectModel new];
    model1.name = @"瘦身";
    model1.age = @"12";
    model1.sex = @"女";
    [localDataArray addObject: model1];

    TestSigleSelectModel *model2 = [TestSigleSelectModel new];
    model2.name = @"哈哈卡";
    model2.age = @"18";
    model2.sex = @"男";
    [localDataArray addObject: model2];

    TestSigleSelectModel *model3 = [TestSigleSelectModel new];
    model3.name = @"啊洒洒";
    model3.age = @"17";
    model3.sex = @"女";
    [localDataArray addObject: model3];

    TestSigleSelectModel *model4 = [TestSigleSelectModel new];
    model4.name = @"阿撒地方";
    model4.age = @"13";
    model4.sex = @"男";
    [localDataArray addObject: model4];

    TestSigleSelectModel *model5 = [TestSigleSelectModel new];
    model5.name = @"网a阿撒";
    model5.age = @"113";
    model5.sex = @"男";
    [localDataArray addObject: model5];

    TestSigleSelectModel *model6 = [TestSigleSelectModel new];
    model6.name = @"李卡";
    model6.age = @"19";
    model6.sex = @"女";
    [localDataArray addObject: model6];

    TestSigleSelectModel *model7 = [TestSigleSelectModel new];
    model7.name = @"予以ud";
    model7.age = @"13";
    model7.sex = @"男";
    [localDataArray addObject: model7];

    !callBack? : callBack(localDataArray);
    
}


@end
