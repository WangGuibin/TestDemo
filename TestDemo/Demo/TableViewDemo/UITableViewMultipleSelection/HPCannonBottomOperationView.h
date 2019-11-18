//
//  HPCannonBottomOperationView.h
//  DY-ios
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 YGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HPCannonBottomOperationViewDelegate <NSObject>

- (void)allSelectAction:(BOOL)isSelectAll;
- (void)deletePostListAction;

@end

@interface HPCannonBottomOperationView : UIView

@property (nonatomic,weak) id<HPCannonBottomOperationViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

NS_ASSUME_NONNULL_END
