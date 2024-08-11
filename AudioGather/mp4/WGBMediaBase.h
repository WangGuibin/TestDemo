//
//  WGBMediaBase.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#ifndef WGBMediaBase_h
#define WGBMediaBase_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WGBMediaType) {
    WGBMediaNone = 0,
    WGBMediaAudio = 1 << 0, // 仅音频。
    WGBMediaVideo = 1 << 1, // 仅视频。
    WGBMediaAV = WGBMediaAudio | WGBMediaVideo,  // 音视频都有。
};

#endif /* WGBMediaBase_h */

/*
 代码来自于CSDN 
 //音频流采集
 https://blog.csdn.net/m0_60259116/article/details/124768304
 iOS音视频开发二：音频编码，采集 PCM 数据编码为 AAC
 https://blog.csdn.net/m0_60259116/article/details/124768508
 //m4a
 https://blog.csdn.net/m0_60259116/article/details/124769050
 //音频解封装aac
 https://blog.csdn.net/m0_60259116/article/details/124769912
 //音频解码
 https://blog.csdn.net/m0_60259116/article/details/124770941
 //音频渲染
 https://blog.csdn.net/m0_60259116/article/details/124801979
 //视频采集
 https://blog.csdn.net/m0_60259116/article/details/124803289
 //视频流编码h264 h265
 https://blog.csdn.net/m0_60259116/article/details/124804169
 
 */
