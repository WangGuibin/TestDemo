//
// WGBPopupControllerManager.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/7/27
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
    

#import "WGBPopupControllerManager.h"
#import "WGBGestureDrivenPopUpController.h"

@interface WGBPopupControllerManager ()

@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WGBGestureDrivenPopUpController *popupController;

@end

@implementation WGBPopupControllerManager

- (instancetype)initWithSuperViewController:(UIViewController *)superViewController contentView:(UIView *)contentView {
    if (self = [super init]) {
        _superViewController = superViewController;
        _contentView = contentView;
    }
    return self;
}

- (void)show {
    self.popupController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.superViewController presentViewController:self.popupController animated:NO completion:^{
        [self.popupController addContentView:self.contentView];
        [self.popupController show];
    }];
}

- (void)dismiss {
    [self.popupController dismiss];
}

- (void)setSpaceToTop:(CGFloat)spaceToTop {
    _spaceToTop = spaceToTop;
    self.popupController.spaceToTop = spaceToTop;
}

- (void)setScaleToDismiss:(CGFloat)scaleToDismiss{
    _scaleToDismiss = scaleToDismiss;
    self.popupController.scaleToDismiss = scaleToDismiss;
}

- (WGBGestureDrivenPopUpController *)popupController {
    if (!_popupController) {
        _popupController = [[WGBGestureDrivenPopUpController alloc] init];
    }
    return _popupController;
}

@end
