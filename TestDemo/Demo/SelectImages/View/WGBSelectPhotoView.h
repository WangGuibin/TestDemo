//
//  WGBSelectPhotoView.h
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WGBSelectPhotoViewDelegate <NSObject>

@optional
//点击图片事件回调
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index;
//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index;

@end


@interface WGBSelectPhotoView : UIView

@property (nonatomic, assign) NSInteger maxCount;//最多显示图片数量 默认9张
@property (nonatomic, assign) NSInteger rowCount;//每行显示图片数量 默认4张

@property (nonatomic, assign) CGFloat margin;//上下左右边距 默认 = 15.0
@property (nonatomic, assign) CGFloat spacing;//图片之间的间距 默认 = 10.0


@property (nonatomic, weak) id <WGBSelectPhotoViewDelegate> delegate;

- (NSUInteger)picturesCount;
- (NSUInteger)pictureButtonsCount;

///MARK:- 添加图片数组
- (void)addPhotoesWithImages:(NSArray *)images;
///MARK:- 添加单张图片 (一张一张添加很烦的 除非需求就是这样)
- (void)addPictureWithImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
