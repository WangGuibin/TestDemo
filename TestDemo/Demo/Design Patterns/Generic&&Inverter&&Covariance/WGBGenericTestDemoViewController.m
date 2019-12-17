//
// WGBGenericTestDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/17
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
    

#import "WGBGenericTestDemoViewController.h"
#import "WGBPerson.h"

@interface WGBGenericTestDemoViewController ()

@end

@implementation WGBGenericTestDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//普通泛型 子类指向父类
- (void)test {
    WGBAndroid *android = [[WGBAndroid alloc] init];
    WGBiOS *ios = [[WGBiOS alloc] init];

    // iOS  指定这个人会的是iOS
    WGBPerson<WGBiOS *> *p = [[WGBPerson alloc]init];
    p.language = ios;

    // Android   指定这个人会的是Android
    WGBPerson<WGBAndroid *> *p1 = [[WGBPerson alloc] init];
    p1.language = android;
}


// 子类转父类 协变
- (void)covariant {

    WGBiOS *ios = [[WGBiOS alloc] init];
//    WGBLanguage *language = [[WGBLanguage alloc] init];

    // iOS 只会iOS
    WGBPerson<WGBiOS *> *p = [[WGBPerson alloc]init];
    p.language = ios;

    // Language 都会
    WGBPerson<WGBLanguage *> *p1 = [[WGBPerson alloc] init];
    p1 = p;

    // 如果没添加协变会报指针类型错误警告
}

//逆变 父类转子类
- (void)contravariant {

    // 第二步 定义泛型
    WGBiOS *ios = [[WGBiOS alloc] init];
    WGBLanguage *language = [[WGBLanguage alloc] init];

    // 父类转子类  都会
    WGBPerson<WGBLanguage *> *p = [[WGBPerson alloc] init];
    p.language = language;

    // iOS  只会iOS
    WGBPerson<WGBiOS *> *p1 = [[WGBPerson alloc] init];
    p1 = p;

    // 如果没添加逆变会报指针类型错误警告
}

@end
