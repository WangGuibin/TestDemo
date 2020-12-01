//
//  YYAnimatedImageView+FixIOS14Display.m
//  TwitterListDemo
//
//  Created by mac on 2020/12/1.
//  Copyright © 2020 Cao Xueliang. All rights reserved.
//

#import "YYAnimatedImageView+FixIOS14Display.h"

//iOS14加载不出图片的问题 https://github.com/ibireme/YYImage/issues/149
@implementation YYAnimatedImageView (FixIOS14Display)

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(displayLayer:));
    Method b = class_getInstanceMethod(self, @selector(swizzing_displayLayer:));
    method_exchangeImplementations(a, b);
}

- (void)swizzing_displayLayer:(CALayer *)layer
{
    //通过变量名称获取类中的实例成员变量
    Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");
    UIImage *_curFrame = object_getIvar(self, ivar);

    if (_curFrame) {
        layer.contents = (__bridge id)_curFrame.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end
