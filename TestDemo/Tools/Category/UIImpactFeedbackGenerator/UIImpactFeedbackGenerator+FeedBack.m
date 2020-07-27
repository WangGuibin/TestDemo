//
// UIImpactFeedbackGenerator+FeedBack.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/7/24
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
    

#import "UIImpactFeedbackGenerator+FeedBack.h"

@implementation UIImpactFeedbackGenerator (FeedBack)

+ (void)generateFeedbackWithStyle:(UIImpactFeedbackStyle)feedbackStyle{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackStyle];
    [generator prepare];
    [generator impactOccurred];
}

+ (void)generateFeedbackWithLightStyle{
    return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleLight];
}

+ (void)generateFeedbackWithMediumStyle{
    return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleMedium];
}

+ (void)generateFeedbackWithHeavyStyle{
    return [UIImpactFeedbackGenerator generateFeedbackWithStyle:UIImpactFeedbackStyleHeavy];
}


@end
