//
//  HPSelectSexAlertView.h
//  DY-ios
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPSelectSexAlertView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) void(^selectSexBlock) (NSInteger index,NSString *selectValue);

@end

NS_ASSUME_NONNULL_END
