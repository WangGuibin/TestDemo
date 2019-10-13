//
//  HPEditSignatureAlertView.h
//  DY-ios
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPEditSignatureAlertView : UIView

@property (nonatomic,copy) void (^editCallBackBlock)(NSString *signatureText,NSInteger index);

@end

NS_ASSUME_NONNULL_END
