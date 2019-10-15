//
//  HPPublishAlertView.h
//  DY-ios
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPPublishAlertView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) void(^selectPublishMediaBlock) (NSInteger index);

@end

NS_ASSUME_NONNULL_END
