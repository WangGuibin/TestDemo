//
//  ShowQRCodeViewController.h
//  TestDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShowQRCodeStyle) {
    ShowQRCodeStyleNormal = 0,
    ShowQRCodeStyleIconBg,
    ShowQRCodeStyleGIFBg,
    ShowQRCodeStyleJPQRTool
};

NS_ASSUME_NONNULL_BEGIN

@interface ShowQRCodeViewController : UIViewController

@property (nonatomic,assign) ShowQRCodeStyle style;

@end

NS_ASSUME_NONNULL_END
