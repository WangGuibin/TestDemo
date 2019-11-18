//
//  HPCommonLeftRightButtonAlertView.m
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import "WGBCommonLeftRightButtonAlertView.h"

@interface WGBCommonLeftRightButtonAlertView()


@end

@implementation WGBCommonLeftRightButtonAlertView

// 提交审核弹窗
+ (WGBCommonLeftRightButtonAlertView *)shareCommitReviewAlertView{
    WGBCommonLeftRightButtonAlertView *alertView = [WGBCommonLeftRightButtonAlertView fromXIBWithIndex:0];
    return alertView;
}

// 引导开通VIP之类的
+ (WGBCommonLeftRightButtonAlertView *)shareGuideVIPAlertView{
    WGBCommonLeftRightButtonAlertView *alertView = [WGBCommonLeftRightButtonAlertView fromXIBWithIndex:1];
    return alertView;
}

// 关闭弹窗
- (IBAction)cancelAction {
    !self.cancelBlock? : self.cancelBlock();
}

//  左边 0 右边 1
- (IBAction)buttonClickAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    !self.clickButtonActionBlock? : self.clickButtonActionBlock(index);
}

@end
