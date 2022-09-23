//
//  FSUnitRecorder.h
//  AudioUnitDemo
//
//  Created by 王贵彬 on 2022/4/29.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^kAudioUnitRecorderOnputBlock)(NSData *bufferData);

//单声道录制音频
@interface FSUnitRecorder : NSObject

@property (assign, nonatomic) double sampleRate;
@property (assign, nonatomic, readonly) BOOL isRecording;
@property (copy, nonatomic) kAudioUnitRecorderOnputBlock bufferListBlock;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
