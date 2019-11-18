//
//  HPCommonCancelConfirmAlertView.h
//  DY-ios
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPCommonCancelConfirmAlertView : UIView

@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *leftButtonTitle;
@property (nonatomic,copy) NSString *rightButtonTitle;
@property (nonatomic,copy) void (^clickButtonActionBlock) (NSInteger index);

@end

NS_ASSUME_NONNULL_END
