//
//  WGBSelectPhotoButton.h
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBSelectPhotoButton : UIButton

@property (nonatomic,assign) BOOL isAddButton;
@property (nonatomic,copy) dispatch_block_t didClickButtonBlock;
@property (nonatomic,copy) dispatch_block_t deletePhotoBlock;

@end

NS_ASSUME_NONNULL_END
