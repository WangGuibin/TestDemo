//
//  WGBSelectPhotoViewConfig.h
//  WGBSelectPhotoView
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 借鉴了 `YBImageBrowser` 的 `YBIBIconManager` 利用`block`自定义传参
*/

@interface UIImage (WGBImageBrowser)

/**
 获取图片便利构造方法

 @param name 图片名字
 @param bundle 资源对象
 @return 图片实例
 */
+ (UIImage *)wgb_imageNamed:(NSString *)name
                        bundle:(NSBundle *)bundle;

@end


typedef UIImage * _Nullable (^WGBIconBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WGBSelectPhotoViewConfig : NSObject

/**
 唯一有效单例
 */
+ (instancetype)sharedManager;

//删除icon
@property (nonatomic,copy) WGBIconBlock deleteButtonImage;
//添加icon
@property (nonatomic,copy) WGBIconBlock addButtonImage;
//视频标识
@property (nonatomic,copy) WGBIconBlock videoMarkImage;

@end

NS_ASSUME_NONNULL_END
