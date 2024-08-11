//
//  WGBAudioRender.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBAudioRender : NSObject


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithChannels:(NSInteger)channels bitDepth:(NSInteger)bitDepth sampleRate:(NSInteger)sampleRate;

@property (nonatomic, copy) void (^audioBufferInputCallBack)(AudioBufferList *audioBufferList); // 音频渲染数据输入回调。
@property (nonatomic, copy) void (^errorCallBack)(NSError *error); // 音频渲染错误回调。
@property (nonatomic, assign, readonly) NSInteger audioChannels; // 声道数。
@property (nonatomic, assign, readonly) NSInteger bitDepth; // 采样位深。
@property (nonatomic, assign, readonly) NSInteger audioSampleRate; // 采样率。

- (void)startPlaying; // 开始渲染。
- (void)stopPlaying; // 结束渲染。


@end

NS_ASSUME_NONNULL_END
