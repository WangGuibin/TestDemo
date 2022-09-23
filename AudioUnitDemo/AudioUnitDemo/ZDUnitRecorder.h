//
//  ZDUnitRecorder.h
//  AudioUnitDemo
//
//  Created by 王贵彬 on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//双声道录音
/**
    使用如下:
    @code
            _recorder.bufferListBlock = ^(AudioBufferList * _Nonnull bufferList) {
             AudioBuffer left = bufferList->mBuffers[0];// 左耳机buffer
             AudioBuffer right = bufferList->mBuffers[1];// 右耳机buffer
             NSData *leftData = [NSData dataWithBytes:left.mData length:left.mDataByteSize];
             NSData *rightData = [NSData dataWithBytes:right.mData length:right.mDataByteSize];
             //对data进行处理
         };
    @endcode
 */

NS_ASSUME_NONNULL_BEGIN
typedef void (^kAudioUnitRecorderOnputBlock)(AudioBufferList *bufferList);

@interface ZDUnitRecorder : NSObject

@property (assign, nonatomic) double sampleRate;
@property (assign, nonatomic, readonly) BOOL isRecording;
@property (copy, nonatomic) kAudioUnitRecorderOnputBlock bufferListBlock;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
