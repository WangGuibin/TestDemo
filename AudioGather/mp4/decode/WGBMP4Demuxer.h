//
//  WGBMP4Demuxer.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "WGBDemuxerConfig.h"

/// 从mp4封装格式中解封装获取buffer数据

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WGBMP4DemuxerStatus) {
    WGBMP4DemuxerStatusUnknown = 0,
    WGBMP4DemuxerStatusRunning = 1,
    WGBMP4DemuxerStatusFailed = 2,
    WGBMP4DemuxerStatusCompleted = 3,
    WGBMP4DemuxerStatusCancelled = 4,
};

@interface WGBMP4Demuxer : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(WGBDemuxerConfig *)config;

@property (nonatomic, strong, readonly) WGBDemuxerConfig *config;
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);
@property (nonatomic, assign, readonly) BOOL hasAudioTrack; // 是否包含音频数据。
@property (nonatomic, assign, readonly) BOOL hasVideoTrack; // 是否包含视频数据。
@property (nonatomic, assign, readonly) CGSize videoSize; // 视频大小。
@property (nonatomic, assign, readonly) CMTime duration; // 媒体时长。
@property (nonatomic, assign, readonly) CMVideoCodecType codecType; // 编码类型。
@property (nonatomic, assign, readonly) WGBMP4DemuxerStatus demuxerStatus; // 解封装器状态。
@property (nonatomic, assign, readonly) BOOL audioEOF; // 是否音频结束。
@property (nonatomic, assign, readonly) BOOL videoEOF; // 是否视频结束。
@property (nonatomic, assign, readonly) CGAffineTransform preferredTransform; // 图像的变换信息。比如：视频图像旋转。

- (void)startReading:(void (^)(BOOL success, NSError *error))completeHandler; // 开始读取数据解封装。
- (void)cancelReading; // 取消读取。

- (BOOL)hasAudioSampleBuffer; // 是否还有音频数据。
- (CMSampleBufferRef)copyNextAudioSampleBuffer CF_RETURNS_RETAINED; // 拷贝下一份音频采样。

- (BOOL)hasVideoSampleBuffer; // 是否还有视频数据。
- (CMSampleBufferRef)copyNextVideoSampleBuffer CF_RETURNS_RETAINED; // 拷贝下一份视频采样。

@end

NS_ASSUME_NONNULL_END

