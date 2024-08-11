//
//  WGBVideoCaptureConfig.m
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import "WGBVideoCaptureConfig.h"

@implementation WGBVideoCaptureConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _preset = AVCaptureSessionPreset1920x1080;
        _position = AVCaptureDevicePositionFront;
        _orientation = AVCaptureVideoOrientationPortrait;
        _fps = 30;
        _mirrorType = WGBVideoCaptureMirrorFront;

        // 设置颜色空间格式，这里要注意了：
        // 1、一般我们采集图像用于后续的编码时，这里设置 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange 即可。
        // 2、如果想支持 HDR 时（iPhone12 及之后设备才支持），这里设置为：kCVPixelFormatType_420YpCbCr10BiPlanarVideoRange。
        _pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    }
    
    return self;
}

@end
