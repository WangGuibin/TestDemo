//
// CATransition+WGBExtension.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/10
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
    

#import "CATransition+WGBExtension.h"

@implementation CATransition (WGBExtension)


/// 创建转场动画对象
/// @param animationType 动画类型
/// @param subType 动画方向类型
/// @param duration 动画时长
+ (CATransition *)wgb_createTransitionWithAnimationType:(WGBTransitionAnimationType)animationType
                              subType:(WGBTransitionAnimationSubType)subType
                             duration:(NSTimeInterval)duration{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    switch (subType) {
        case WGBTransitionAnimationSubTypeFromRight:
        {
            transition.subtype = kCATransitionFromRight;
        }
            break;
        case WGBTransitionAnimationSubTypeFromLeft:
        {
            transition.subtype = kCATransitionFromLeft;
            
        }
            break;
        case WGBTransitionAnimationSubTypeFromTop:
        {
            transition.subtype = kCATransitionFromTop;
            
        }
            break;
        case WGBTransitionAnimationSubTypeFromBottom:
        {
            transition.subtype = kCATransitionFromBottom;
            
        }
            break;
            
        default:
        {
            transition.subtype = kCATransitionFromRight;
        }
            break;
    }
    
    switch (animationType) {
        case WGBTransitionAnimationTypePublicFade:
        {
            transition.type = kCATransitionFade;
            transition.subtype = nil; //不支持过渡方向设置(下同)
        }
            break;
        case WGBTransitionAnimationTypePublicPush:
        {
            transition.type = kCATransitionPush;
        }
            break;
        case WGBTransitionAnimationTypePublicMoveIn:
        {
            transition.type = kCATransitionMoveIn;
        }
            break;
        case WGBTransitionAnimationTypePublicReveal:
        {
            transition.type = kCATransitionReveal;
        }
            break;
        case WGBTransitionAnimationTypePrivateCube:
        {
            transition.type = @"cube";
        }
            break;
        case WGBTransitionAnimationTypePrivateSuckEffect:
        {
            transition.type = @"suckEffect";
            transition.subtype = nil;
        }
            break;
        case WGBTransitionAnimationTypePrivateOglFlip:
        {
            transition.type = @"oglFlip";
        }
            break;
        case WGBTransitionAnimationTypePrivateRippleEffect:
        {
            transition.type = @"rippleEffect";
            transition.subtype = nil;
        }
            break;
        case WGBTransitionAnimationTypePrivatePageCurl:
        {
            transition.type = @"pageCurl";
        }
            break;
        case WGBTransitionAnimationTypePrivatePageUnCurl:
        {
            transition.type = @"pageUnCurl";
        }
            break;
        case WGBTransitionAnimationTypePrivateCameraIrisHollowOpen:
        {
            transition.type = @"cameraIrisHollowOpen";
            transition.subtype = nil;
        }
            break;
        case WGBTransitionAnimationTypePrivateCameraIrisHollowClose:
        {
            transition.type = @"cameraIrisHollowClose";
            transition.subtype = nil;
        }
            break;
            
        default:
        {
            transition.type = kCATransitionFade;
        }
            break;
    }
    return transition;
}



@end
