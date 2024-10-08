//
//  WGBVideoEncoderConfig.m
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import "WGBVideoEncoderConfig.h"
#import <VideoToolBox/VideoToolBox.h>

@implementation WGBVideoEncoderConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(1080, 1920);
        _bitrate = 5000 * 1024;
        _fps = 30;
        _gopSize = _fps * 5;
        _openBFrame = YES;
        
        BOOL supportHEVC = NO;
        if (@available(iOS 11.0, *)) {
            if (&VTIsHardwareDecodeSupported) {
                supportHEVC = VTIsHardwareDecodeSupported(kCMVideoCodecType_HEVC);
            }
        }
        
        _codecType = supportHEVC ? kCMVideoCodecType_HEVC : kCMVideoCodecType_H264;
        _profile = supportHEVC ? (__bridge NSString *) kVTProfileLevel_HEVC_Main_AutoLevel : AVVideoProfileLevelH264HighAutoLevel;
    }
    
    return self;
}

@end
