//
//  WMImageBrowerTransitionView.h
//  Weimai
//
//  Created by 王贵彬 on 2020/4/19.
//  Copyright © 2020 微脉科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMImageBrowerTransitionView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     imgModel:(NSArray *)modelArray;

/// 滚动过程中 图片高度变化
@property (nonatomic, copy) void(^scrollUpdateHeightBlock) (CGFloat moveHeight);
/// 水平滚动偏移量回调
@property (nonatomic, copy) void(^scrollDidScrollBlock) (CGFloat offsetX);


@end

NS_ASSUME_NONNULL_END
