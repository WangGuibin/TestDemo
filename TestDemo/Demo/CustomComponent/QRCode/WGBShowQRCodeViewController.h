//
//  ShowQRCodeViewController.h
//  TestDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WGBShowQRCodeStyle) {
     WGBShowQRCodeStyleNormal = 0,
     WGBShowQRCodeStyleIconBg,
     WGBShowQRCodeStyleGIFBg,
     WGBShowQRCodeStyleJPQRTool
};

NS_ASSUME_NONNULL_BEGIN

@interface WGBShowQRCodeViewController : UIViewController

@property (nonatomic,assign)  WGBShowQRCodeStyle style;

@end

NS_ASSUME_NONNULL_END
