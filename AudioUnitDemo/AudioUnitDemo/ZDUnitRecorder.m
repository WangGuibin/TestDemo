//
//  ZDUnitRecorder.m
//  AudioUnitDemo
//
//  Created by 王贵彬 on 2022/4/29.
//

#import "ZDUnitRecorder.h"


@interface ZDUnitRecorder ()
{
    AudioUnit audioUnit;
    BOOL audioComponentInitialized;
}

@property (nonatomic,assign) AudioStreamBasicDescription inputStreamDesc;

@end

@implementation ZDUnitRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [super init];
        if (self) {
            [self defaultSetting];
        }
        return self;
    }
    return self;
}

- (void)defaultSetting {
    NSArray *sampleRates = @[@16000, @11025, @22050, @44100];
    for (NSNumber *sampleRate in sampleRates) {
        OSStatus status = [self prepareRecord:sampleRate.doubleValue];
        if (status == noErr) {
            self.sampleRate = [sampleRate doubleValue];
            break;
        }
    }
}

- (OSStatus)prepareRecord:(double)sampleRate {
    OSStatus status = noErr;

    NSError *error;
    AVAudioSessionCategoryOptions options = AVAudioSessionCategoryOptionMixWithOthers
    | AVAudioSessionCategoryOptionAllowBluetooth
    | AVAudioSessionCategoryOptionDefaultToSpeaker
    | AVAudioSessionCategoryOptionAllowAirPlay
    | AVAudioSessionCategoryOptionAllowBluetoothA2DP;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:options
                                           error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

#ifdef IGNORE
    NSInteger inputChannels = session.inputNumberOfChannels;
    if (!inputChannels) {
        NSLog(@"ERROR: NO AUDIO INPUT DEVICE");
        return -1;
  }
#endif

      if (!audioComponentInitialized) {
        audioComponentInitialized = YES;
        // 描述音频组件
        AudioComponentDescription audioComponentDescription;
        audioComponentDescription.componentType = kAudioUnitType_Output;
        audioComponentDescription.componentSubType = kAudioUnitSubType_RemoteIO;
        audioComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
        audioComponentDescription.componentFlags = 0;
        audioComponentDescription.componentFlagsMask = 0;

        // 查找音频单元
        AudioComponent remoteIOComponent = AudioComponentFindNext(NULL, &audioComponentDescription);
        // 创建音频单元实例
        status = AudioComponentInstanceNew(remoteIOComponent, &(self->audioUnit));
        if (CheckError(status, "Couldn't get RemoteIO unit instance")) {
            return status;
        }
      }

      UInt32 oneFlag = 1;
      AudioUnitElement bus0 = 0;
      AudioUnitElement bus1 = 1;

      if ((NO)) {
        // Configure the RemoteIO unit for playback
        status = AudioUnitSetProperty (self->audioUnit,
                                       kAudioOutputUnitProperty_EnableIO,
                                       kAudioUnitScope_Output,
                                       bus0,
                                       &oneFlag,
                                       sizeof(oneFlag));
        if (CheckError(status, "Couldn't enable RemoteIO output")) {
          return status;
        }
      }

      // Configure the RemoteIO unit for input
      status = AudioUnitSetProperty(self->audioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    bus1,
                                    &oneFlag,
                                    sizeof(oneFlag));
      if (CheckError(status, "Couldn't enable RemoteIO input")) {
        return status;
      }
// 音频流基础描述
    AudioStreamBasicDescription asbd = {0};
    asbd.mSampleRate = sampleRate;//采样率
    asbd.mFormatID = kAudioFormatLinearPCM;//原始数据为PCM格式
    asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved;
    asbd.mChannelsPerFrame = 2;//每帧的声道数量
    asbd.mFramesPerPacket = 1;//每个数据包多少帧
    asbd.mBitsPerChannel = 16;//16位
    asbd.mBytesPerFrame = asbd.mChannelsPerFrame * asbd.mBitsPerChannel / 8;//每帧多少字节 bytes -> bit / 8
    asbd.mBytesPerPacket = asbd.mFramesPerPacket * asbd.mBytesPerFrame;//每个包多少字节

      // Set format for output (bus 0) on the RemoteIO's input scope
      status = AudioUnitSetProperty(self->audioUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    bus0,
                                    &asbd,
                                    sizeof(asbd));
      if (CheckError(status, "Couldn't set the ASBD for RemoteIO on input scope/bus 0")) {
        return status;
      }

      // Set format for mic input (bus 1) on RemoteIO's output scope
      status = AudioUnitSetProperty(self->audioUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    bus1,
                                    &asbd,
                                    sizeof(asbd));
      if (CheckError(status, "Couldn't set the ASBD for RemoteIO on output scope/bus 1")) {
        return status;
      }

      // Set the recording callback
      AURenderCallbackStruct callbackStruct;
      callbackStruct.inputProc = inputCallBackFun;
      callbackStruct.inputProcRefCon = (__bridge void *) self;
      status = AudioUnitSetProperty(self->audioUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Global,
                                    bus1,
                                    &callbackStruct,
                                    sizeof (callbackStruct));
      if (CheckError(status, "Couldn't set RemoteIO's render callback on bus 0")) {
        return status;
      }

      if ((NO)) {
        // Set the playback callback
        AURenderCallbackStruct callbackStruct;
        callbackStruct.inputProc = playbackCallback;
        callbackStruct.inputProcRefCon = (__bridge void *) self;
        status = AudioUnitSetProperty(self->audioUnit,
                                      kAudioUnitProperty_SetRenderCallback,
                                      kAudioUnitScope_Global,
                                      bus0,
                                      &callbackStruct,
                                      sizeof (callbackStruct));
        if (CheckError(status, "Couldn't set RemoteIO's render callback on bus 0")) {
          return status;
        }
      }

      // Initialize the RemoteIO unit
      status = AudioUnitInitialize(self->audioUnit);
      if (CheckError(status, "Couldn't initialize the RemoteIO unit")) {
        return status;
      }

      return status;
}

- (void)start {
    [self deleteAudioFile];
    CheckError(AudioOutputUnitStart(audioUnit), "AudioOutputUnitStop failed");
    _isRecording = YES;
}

- (void)stop {
    CheckError(AudioOutputUnitStop(audioUnit),
    "AudioOutputUnitStop failed");
    _isRecording = NO;
}

- (void)deleteAudioFile {
    NSString *pcmPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"record.mp3"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pcmPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:pcmPath error:nil];
    }
}

- (void)dealloc {
    CheckError(AudioComponentInstanceDispose(audioUnit),
               "AudioComponentInstanceDispose failed");
    NSLog(@"UnitRecorder销毁");
}

static OSStatus CheckError(OSStatus error, const char *operation) {
  if (error == noErr) {
    return error;
  }
  char errorString[20] = "";
  // See if it appears to be a 4-char-code
  *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
  if (isprint(errorString[1]) && isprint(errorString[2]) &&
      isprint(errorString[3]) && isprint(errorString[4])) {
    errorString[0] = errorString[5] = '\'';
    errorString[6] = '\0';
  } else {
    // No, format it as an integer
    sprintf(errorString, "%d", (int)error);
  }
  fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
  return error;
}

static OSStatus playbackCallback(void *inRefCon,
                                 AudioUnitRenderActionFlags *ioActionFlags,
                                 const AudioTimeStamp *inTimeStamp,
                                 UInt32 inBusNumber,
                                 UInt32 inNumberFrames,
                                 AudioBufferList *ioData) {
  OSStatus status = noErr;

  // Notes: ioData contains buffers (may be more than one!)
  // Fill them up as much as you can. Remember to set the size value in each buffer to match how
  // much data is in the buffer.
  ZDUnitRecorder *recorder = (__bridge ZDUnitRecorder *) inRefCon;

  UInt32 bus1 = 1;
  status = AudioUnitRender(recorder->audioUnit,
                           ioActionFlags,
                           inTimeStamp,
                           bus1,
                           inNumberFrames,
                           ioData);
  CheckError(status, "Couldn't render from RemoteIO unit");
  return status;
}

static OSStatus inputCallBackFun(void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList * __nullable ioData)
{
    ZDUnitRecorder *recorder = (__bridge ZDUnitRecorder *)(inRefCon);
    
    AudioBuffer buffer;
    buffer.mData = NULL;
    buffer.mDataByteSize = 0;
    buffer.mNumberChannels = 2;
    
    AudioBuffer buffer2;
    buffer2.mData = NULL;
    buffer2.mDataByteSize = 0;
    buffer2.mNumberChannels = 2;
            
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 2;
    bufferList.mBuffers[0] = buffer;
    bufferList.mBuffers[1] = buffer2;
    
    AudioUnitRender(recorder->audioUnit,
                    ioActionFlags,
                    inTimeStamp,
                    inBusNumber,
                    inNumberFrames,
                    &bufferList);
    if (recorder.bufferListBlock) {
        recorder.bufferListBlock(&bufferList);
    }
    return noErr;
}

@end
