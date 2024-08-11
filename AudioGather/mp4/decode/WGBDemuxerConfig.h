//
//  WGBDemuxerConfig.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "WGBMediaBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBDemuxerConfig : NSObject

@property (nonatomic, strong) AVAsset *asset; // 待解封装的资源。
@property (nonatomic, assign) WGBMediaType demuxerType; // 解封装类型。

@end

NS_ASSUME_NONNULL_END
