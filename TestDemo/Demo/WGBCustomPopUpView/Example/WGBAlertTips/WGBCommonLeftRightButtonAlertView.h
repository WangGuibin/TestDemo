//
//  WGBCommonLeftRightButtonAlertView.h
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBCommonLeftRightButtonAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) void(^clickButtonActionBlock) (NSInteger index);

// 提交审核弹窗
+ (WGBCommonLeftRightButtonAlertView *)shareCommitReviewAlertView;

// 引导开通VIP之类的
+ (WGBCommonLeftRightButtonAlertView *)shareGuideVIPAlertView;

@end


NS_ASSUME_NONNULL_END
