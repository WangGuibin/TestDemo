//
//  WGBVideoCaptureConfig.h
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WGBVideoCaptureMirrorType) {
    WGBVideoCaptureMirrorNone = 0,
    WGBVideoCaptureMirrorFront = 1 << 0,
    WGBVideoCaptureMirrorBack = 1 << 1,
    WGBVideoCaptureMirrorAll = (WGBVideoCaptureMirrorFront | WGBVideoCaptureMirrorBack),
};

@interface WGBVideoCaptureConfig : NSObject

@property (nonatomic, copy) AVCaptureSessionPreset preset; // 视频采集参数，比如分辨率等，与画质相关。
@property (nonatomic, assign) AVCaptureDevicePosition position; // 摄像头位置，前置/后置摄像头。
@property (nonatomic, assign) AVCaptureVideoOrientation orientation; // 视频画面方向。
@property (nonatomic, assign) NSInteger fps; // 视频帧率。
@property (nonatomic, assign) OSType pixelFormatType; // 颜色空间格式。
@property (nonatomic, assign) WGBVideoCaptureMirrorType mirrorType; // 镜像类型。

@end


NS_ASSUME_NONNULL_END
