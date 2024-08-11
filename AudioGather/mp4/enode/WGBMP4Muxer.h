//
//  WGBMP4Muxer.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "WGBMuxerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBMP4Muxer : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(WGBMuxerConfig *)config;

@property (nonatomic, strong, readonly) WGBMuxerConfig *config;
@property (nonatomic, copy) void (^errorCallBack)(NSError *error); // 封装错误回调。

- (void)startWriting; // 开始封装写入数据。
- (void)cancelWriting; // 取消封装写入数据。
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer; // 添加封装数据。
- (void)stopWriting:(void (^)(BOOL success, NSError *error))completeHandler; // 停止封装写入数据。


@end

NS_ASSUME_NONNULL_END
