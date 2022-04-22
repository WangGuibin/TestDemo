//
//  ViewController.m
//  AudioUnitDemo
//
//  Created by 王贵彬(EX-WANGGUIBIN001) on 2022/4/19.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "XBPCMPlayer.h"
#import "CMAudioSession.h"
#import "GSNAudioUnitGraph.h"

#define kSampleRate  44100
#define kBits 16
#define kChannels 1

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

@interface ViewController ()<CMAudioSessionDelegate>

@property (nonatomic,assign) BOOL isRecording;
@property(nonatomic,strong)XBPCMPlayer *palyer;

@property (nonatomic,strong) CMAudioSession *aacSession; //aac录制方案
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) GSNAudioUnitGraph *audioUnitGraph;//audioUnitGraph pcm录制备用方案

@end

@implementation ViewController
{
    AudioUnit audioUnit;//audioUnit直接录制
}


- (void)setupButtonWithY:(CGFloat)lastY
                   title:(NSString *)title
                  action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, lastY, 200 , 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (CMAudioSession *)aacSession{
    if (!_aacSession) {
        _aacSession = [[CMAudioSession alloc] init];
        _aacSession.delegate = self;
    }
    return _aacSession;
}

- (GSNAudioUnitGraph *)audioUnitGraph {
    if (!_audioUnitGraph) {
        _audioUnitGraph = [[GSNAudioUnitGraph alloc] init];
    }
    return _audioUnitGraph;
}

/// <CMAudioSessionDelegate>
- (void)audioSessionBackData:(NSData*)audioData{
    if (audioData) {
        [self writeAACData:(Byte *)audioData.bytes size:(int)audioData.length];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtonWithY:180 title:@"录制PCM" action:@selector(startRecordPCM:)];
    [self setupButtonWithY:260 title:@"播放PCM" action:@selector(playAudio:)];
    [self setupButtonWithY:340 title:@"AAC录制" action:@selector(recAAC:)];
    [self setupButtonWithY:420 title:@"AAC播放" action:@selector(playAAC:)];
}

- (void)recAAC:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"AAC录制"]) {
        [sender setTitle:@"AAC停止录制" forState:UIControlStateNormal];
        [self.aacSession startAudioUnitRecorder];
    }else{
        [sender setTitle:@"AAC录制" forState:UIControlStateNormal];
        [self.aacSession stopAudioUnitRecorder];
    }
}
- (void)playAAC:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"AAC播放"]) {
        [sender setTitle:@"AAC停止播放" forState:UIControlStateNormal];
        if (!self.audioPlayer) {
            [self playAudioTest];
        }else{
            [self.audioPlayer play];
        }
    }else{
        [self.audioPlayer pause];
        [sender setTitle:@"AAC播放" forState:UIControlStateNormal];
    }
}

///播放aac
- (void)playAudioTest{
    //后台播放代码...
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/record.aac"];
    NSData *fileData = [NSData dataWithContentsOfFile:path options:NSDataReadingMapped error:nil];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:fileData
                                                          error:nil];
    player.numberOfLoops = HUGE;
    self.audioPlayer = player;
    
    if (player != nil) {
        if ([player prepareToPlay] == YES &&
            [player play] == YES) {
        }
    }
}

- (void)playPCM{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/record.pcm"];
    self.palyer = [[XBPCMPlayer alloc] initWithPCMFilePath:path rate:kSampleRate channels:kChannels bit:kBits];
    [self.palyer play];
}
- (void)playAudio:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"播放PCM"]) {
        [self playPCM];
        [sender setTitle:@"停止播放PCM" forState:UIControlStateNormal];
    }else{
        [self.palyer stop];
        self.palyer = nil;
        [sender setTitle:@"播放PCM" forState:UIControlStateNormal];
    }
}

- (void)startRecordPCM:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"录制PCM"]) {
        //[self.audioUnitGraph audioUnitStartRecordAndPlay];
        self.isRecording = YES;
        [self initInputAudioUnitWithRate:kSampleRate bit:kBits channel:kChannels];
        AudioOutputUnitStart(audioUnit);
        [sender setTitle:@"停止录制PCM" forState:UIControlStateNormal];
    }else{
        //[self.audioUnitGraph audioUnitStop];
        self.isRecording = NO;
        CheckError(AudioOutputUnitStop(audioUnit),
                   "AudioOutputUnitStop failed");
        CheckError(AudioComponentInstanceDispose(audioUnit),
                   "AudioComponentInstanceDispose failed");
        [sender setTitle:@"录制PCM" forState:UIControlStateNormal];
    }
}

- (void)initInputAudioUnitWithRate:(UInt32)rate
                               bit:(UInt32)bit
                           channel:(UInt32)channel{
    //设置AVAudioSession
    NSError *error = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [session setActive:YES error:nil];
    
    //初始化audioUnit 音频单元描述 kAudioUnitSubType_RemoteI
    AudioComponentDescription inputDesc;
    inputDesc.componentType = kAudioUnitType_Output;
    inputDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    inputDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    inputDesc.componentFlags = 0;
    inputDesc.componentFlagsMask = 0;
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &inputDesc);
    AudioComponentInstanceNew(inputComponent, &audioUnit);
    
    //设置输出流格式为PCM格式
    int mFramesPerPacket = 1;
    AudioStreamBasicDescription inputStreamDesc;
    memset(&inputStreamDesc, 0, sizeof(inputStreamDesc));
    inputStreamDesc.mSampleRate       = rate;
    inputStreamDesc.mFormatID         = kAudioFormatLinearPCM;
    inputStreamDesc.mFormatFlags      = (kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagIsPacked);
    inputStreamDesc.mFramesPerPacket  = mFramesPerPacket;
    inputStreamDesc.mChannelsPerFrame = (UInt32)channel;
    inputStreamDesc.mBitsPerChannel   = (UInt32)bit;//采样精度
    inputStreamDesc.mBytesPerFrame    = (UInt32)(bit * channel / 8);//每帧的字节数 16 * 2 /8
    inputStreamDesc.mBytesPerPacket   = (UInt32)(bit * channel / 8 * mFramesPerPacket);
    
    OSStatus status = AudioUnitSetProperty(audioUnit,
                                           kAudioUnitProperty_StreamFormat,
                                           kAudioUnitScope_Output,
                                           1,
                                           &inputStreamDesc,
                                           sizeof(inputStreamDesc));
    CheckError(status, "setProperty StreamFormat error");
    
    //麦克风输入设置为1（yes）
    int inputEnable = 1;
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  1,
                                  &inputEnable,
                                  sizeof(inputEnable));
    CheckError(status, "setProperty EnableIO error");
    
    //设置回调
    AURenderCallbackStruct inputCallBackStruce;
    inputCallBackStruce.inputProc = inputCallBackFun;
    inputCallBackStruce.inputProcRefCon = (__bridge void * _Nullable)(self);
    
    status = AudioUnitSetProperty(audioUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Output,
                                  1,
                                  &inputCallBackStruce,
                                  sizeof(inputCallBackStruce));
    CheckError(status, "setProperty InputCallback error");
}

static OSStatus inputCallBackFun(void * inRefCon,
                                 AudioUnitRenderActionFlags *    ioActionFlags,
                                 const AudioTimeStamp *            inTimeStamp,
                                 UInt32                            inBusNumber,
                                 UInt32                            inNumberFrames,
                                 AudioBufferList * __nullable ioData){
    
    ViewController *recorder = (__bridge ViewController *)(inRefCon);
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = NULL;
    bufferList.mBuffers[0].mDataByteSize = 0;
    
    AudioUnitRender(recorder->audioUnit,
                    ioActionFlags,
                    inTimeStamp,
                    1,
                    inNumberFrames,
                    &bufferList);
    AudioBuffer buffer = bufferList.mBuffers[0];
    int len = buffer.mDataByteSize;
//    NSData *data = [NSData dataWithBytes:buffer.mData length:len];
    if (recorder.isRecording) {
        [recorder writePCMData:buffer.mData size:len];
    }
    return noErr;
}

- (void)writePCMData:(Byte *)buffer size:(int)size {
    static FILE *file = NULL;
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/record.pcm"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"path =  %@",path);
    });
    
    if (!file) {
        file = fopen(path.UTF8String, "w");
    }
    fwrite(buffer, size, 1, file);
}
- (void)writeAACData:(Byte *)buffer size:(int)size {
    static FILE *file = NULL;
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/record.aac"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"path =  %@",path);
    });
    
    if (!file) {
        file = fopen(path.UTF8String, "w");
    }
    fwrite(buffer, size, 1, file);
}

@end
