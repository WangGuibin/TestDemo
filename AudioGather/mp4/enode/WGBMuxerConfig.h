//
//  WGBMuxerConfig.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "WGBMediaBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBMuxerConfig : NSObject

@property (nonatomic, strong) NSURL *outputURL; // 封装文件输出地址。
@property (nonatomic, assign) WGBMediaType muxerType; // 封装文件类型。
@property (nonatomic, assign) CGAffineTransform preferredTransform; // 图像的变换信息。比如：视频图像旋转。

@end

NS_ASSUME_NONNULL_END
