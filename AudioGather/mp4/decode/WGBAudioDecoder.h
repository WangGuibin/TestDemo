//
//  WGBAudioDecoder.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBAudioDecoder : NSObject

@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample); // 解码器数据回调。
@property (nonatomic, copy) void (^errorCallBack)(NSError *error); // 解码器错误回调。

- (void)decodeSampleBuffer:(CMSampleBufferRef)sampleBuffer; // 解码。

@end

NS_ASSUME_NONNULL_END
