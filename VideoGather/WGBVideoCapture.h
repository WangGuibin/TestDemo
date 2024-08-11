//
//  WGBVideoCapture.h
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import <Foundation/Foundation.h>
#import "WGBVideoCaptureConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBVideoCapture : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(WGBVideoCaptureConfig *)config;

@property (nonatomic, strong, readonly) WGBVideoCaptureConfig *config;
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览渲染 layer。
@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample); // 视频采集数据回调。
@property (nonatomic, copy) void (^sessionErrorCallBack)(NSError *error); // 视频采集会话错误回调。
@property (nonatomic, copy) void (^sessionInitSuccessCallBack)(void); // 视频采集会话初始化成功回调。

- (void)startRunning; // 开始采集。
- (void)stopRunning; // 停止采集。
- (void)changeDevicePosition:(AVCaptureDevicePosition)position; // 切换摄像头。

@end

NS_ASSUME_NONNULL_END
