//
//  XBPCMPlayer.m
//  XBVoiceTool
//
//  Created by xxb on 2018/7/2.
//  Copyright © 2018年 xxb. All rights reserved.
//

#import "XBPCMPlayer.h"
#import <AVKit/AVKit.h>

static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    char errorString[20];
    // See if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

@class XBAudioUnitPlayer;

typedef void (^XBAudioUnitPlayerInputBlock)(AudioBufferList *bufferList);
typedef void (^XBAudioUnitPlayerInputBlockFull)(XBAudioUnitPlayer *player,
                                                AudioUnitRenderActionFlags *ioActionFlags,
                                                const AudioTimeStamp *inTimeStamp,
                                                UInt32 inBusNumber,
                                                UInt32 inNumberFrames,
                                                AudioBufferList *ioData);

@interface XBAudioUnitPlayer : NSObject
@property (nonatomic,copy) XBAudioUnitPlayerInputBlock bl_input;
@property (nonatomic,copy) XBAudioUnitPlayerInputBlockFull bl_inputFull;
- (instancetype)initWithRate:(UInt32)rate
                         bit:(UInt32)bit
                     channel:(UInt32)channel;
- (void)start;
- (void)stop;
@end

@interface XBAudioUnitPlayer ()
{
    AudioUnit audioUnit;
}
@property (nonatomic,assign) UInt32 bit;
@property (nonatomic,assign) UInt32 rate;
@property (nonatomic,assign) UInt32 channel;
@end

@implementation XBAudioUnitPlayer

- (instancetype)initWithRate:(UInt32)rate
                         bit:(UInt32)bit
                     channel:(UInt32)channel
{
    if (self = [super init])
    {
        self.rate = rate;
        self.bit = bit;
        self.channel = channel;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.rate = 44100;
        self.bit = 16;
        self.channel = 1;
    }
    return self;
}

- (void)initAudioUnitWithRate:(UInt32)rate
                          bit:(UInt32)bit
                      channel:(UInt32)channel{
    //设置session
    NSError *error = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [session setActive:YES error:nil];
    
    //初始化audioUnit 输出
    AudioComponentDescription outputDesc ;
    outputDesc.componentType = kAudioUnitType_Output;
    outputDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    outputDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    outputDesc.componentFlags = 0;
    outputDesc.componentFlagsMask = 0;
    AudioComponent outputComponent = AudioComponentFindNext(NULL, &outputDesc);
    AudioComponentInstanceNew(outputComponent, &audioUnit);
    
    
    //设置输出格式
    int mFramesPerPacket = 1;
    AudioStreamBasicDescription streamDesc;
    memset(&streamDesc, 0, sizeof(streamDesc));
    streamDesc.mSampleRate       = rate;
    streamDesc.mFormatID         = kAudioFormatLinearPCM;
    streamDesc.mFormatFlags      = (kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved);
    streamDesc.mFramesPerPacket  = mFramesPerPacket;
    streamDesc.mChannelsPerFrame = channel;
    streamDesc.mBitsPerChannel   = bit;//采样精度
    streamDesc.mBytesPerFrame    = bit * channel / 8;//每帧的字节数 16 * 2 /8
    streamDesc.mBytesPerPacket   = bit * channel / 8 * mFramesPerPacket;

    
    OSStatus status = AudioUnitSetProperty(audioUnit,
                                           kAudioUnitProperty_StreamFormat,
                                           kAudioUnitScope_Input,
                                           0,
                                           &streamDesc,
                                           sizeof(streamDesc));
    CheckError(status, "SetProperty StreamFormat failure");
    
    //设置回调
    AURenderCallbackStruct outputCallBackStruct;
    outputCallBackStruct.inputProc = outputCallBackFun;
    outputCallBackStruct.inputProcRefCon = (__bridge void * _Nullable)(self);
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &outputCallBackStruct,
                                  sizeof(outputCallBackStruct));
    CheckError(status, "SetProperty EnableIO failure");
}


- (void)start
{
    [self initAudioUnitWithRate:self.rate bit:self.bit channel:self.channel];
    AudioOutputUnitStart(audioUnit);
}

- (void)stop
{
    OSStatus status;
    status = AudioOutputUnitStop(audioUnit);
    CheckError(status, "audioUnit停止失败");

    status = AudioComponentInstanceDispose(audioUnit);
    CheckError(status, "audioUnit释放失败");
}
static OSStatus outputCallBackFun(    void *                            inRefCon,
                    AudioUnitRenderActionFlags *    ioActionFlags,
                    const AudioTimeStamp *            inTimeStamp,
                    UInt32                            inBusNumber,
                    UInt32                            inNumberFrames,
                    AudioBufferList * __nullable    ioData)
{
    memset(ioData->mBuffers[0].mData, 0, ioData->mBuffers[0].mDataByteSize);
    
    XBAudioUnitPlayer *player = (__bridge XBAudioUnitPlayer *)(inRefCon);
    if (player.bl_input)
    {
        player.bl_input(ioData);
    }
    if (player.bl_inputFull)
    {
        player.bl_inputFull(player, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData);
    }
    return noErr;
}

@end


@interface XBAudioDataReader : NSObject
@property (nonatomic,assign) UInt32 readerLength;
- (int)readDataFrom:(NSData *)dataStore len:(int)len forData:(Byte *)data;
@end
@implementation XBAudioDataReader

- (int)readDataFrom:(NSData *)dataStore len:(int)len forData:(Byte *)data{
    UInt32 currentReadLength = 0;
    if (_readerLength >= dataStore.length)
    {
        _readerLength = 0;
        return currentReadLength;
    }
    if (_readerLength+ len <= dataStore.length)
    {
        _readerLength = _readerLength + len;
        currentReadLength = len;
    }
    else
    {
        currentReadLength = (UInt32)(dataStore.length - _readerLength);
        _readerLength = (UInt32) dataStore.length;
    }
    
    NSData *subData = [dataStore subdataWithRange:NSMakeRange(_readerLength, currentReadLength)];
    Byte *tempByte = (Byte *)[subData bytes];
    memcpy(data,tempByte,currentReadLength);
    
    
    return currentReadLength;
}
@end


@interface XBPCMPlayer ()

@property (nonatomic,strong) NSData *dataStore;
@property (nonatomic,strong) XBAudioUnitPlayer *player;
@property (nonatomic,strong) XBAudioDataReader *reader;

@end

@implementation XBPCMPlayer

- (instancetype)initWithPCMFilePath:(NSString *)filePath
                               rate:(UInt32)rate
                           channels:(UInt32)channels
                                bit:(UInt32)bit
{
    if (self = [super init])
    {
        self.filePath = filePath;
        self.player = [[XBAudioUnitPlayer alloc] initWithRate:rate bit:bit channel:channels];
        self.reader = [XBAudioDataReader new];
    }
    return self;
}


- (void)play{
    if (self.player.bl_input == nil){
        typeof(self) __weak weakSelf = self;
        self.player.bl_input = ^(AudioBufferList *bufferList) {

            AudioBuffer buffer = bufferList->mBuffers[0];
            int len = buffer.mDataByteSize;
            int readLen = [weakSelf.reader readDataFrom:weakSelf.dataStore len:len forData:buffer.mData];//读取录音文件
            buffer.mDataByteSize = readLen;
            if (readLen == 0){
                [weakSelf stop];
            }
        };
    }
    [self.player start];
    self.isPlaying = YES;
}
- (void)stop{
    self.player.bl_input = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player stop];
        self.isPlaying = NO;
    });
}


#pragma mark - 方法重写
- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    self.dataStore = [NSData dataWithContentsOfFile:filePath];
}


@end
