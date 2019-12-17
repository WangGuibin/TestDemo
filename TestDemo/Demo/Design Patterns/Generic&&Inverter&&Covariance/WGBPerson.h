//
// WGBPerson.h
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
    

#import <Foundation/Foundation.h>
//__covariant : 子类型可以强转到父类型（里氏替换原则）
//__contravariant : 父类型可以强转到子类型（WTF?） 这个很少用到
//两个关键字不能同时存在。
NS_ASSUME_NONNULL_BEGIN
//协变 子类可转父类
@interface WGBPerson<__covariant ObjectType> : NSObject

@property (nonatomic,strong) ObjectType language;

@end

@interface WGBLanguage : NSObject


@end

@interface WGBiOS : WGBLanguage


@end

@interface WGBAndroid : WGBLanguage


@end

NS_ASSUME_NONNULL_END
