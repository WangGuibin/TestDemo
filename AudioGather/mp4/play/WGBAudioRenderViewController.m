//
//  WGBAudioRenderViewController.m

//
//  Created by 王贵彬  on 2023/5/10.
//

#import "WGBAudioRenderViewController.h"

#import "WGBAudioRender.h"
#import "WGBMP4Demuxer.h"
#import "WGBAudioDecoder.h"
#import "WGBFileSelectManager.h"

#define KFDecoderMaxCache 4096 * 5 // 解码数据缓冲区最大长度。

@interface WGBAudioRenderViewController ()

@property (nonatomic, strong) WGBDemuxerConfig *demuxerConfig;
@property (nonatomic, strong) WGBMP4Demuxer *demuxer;
@property (nonatomic, strong) WGBAudioDecoder *decoder;
@property (nonatomic, strong) WGBAudioRender *audioRender;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSMutableData *pcmDataCache; // 解码数据缓冲区。
@property (nonatomic, assign) NSInteger pcmDataCacheLength;
@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation WGBAudioRenderViewController
#pragma mark - Property
- (WGBDemuxerConfig *)demuxerConfig {
    if (!_demuxerConfig) {
        _demuxerConfig = [[WGBDemuxerConfig alloc] init];
        _demuxerConfig.demuxerType = WGBMediaAudio;
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
        _demuxerConfig.asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    }
    
    return _demuxerConfig;
}

- (WGBMP4Demuxer *)demuxer {
    if (!_demuxer) {
        _demuxer = [[WGBMP4Demuxer alloc] initWithConfig:self.demuxerConfig];
        _demuxer.errorCallBack = ^(NSError *error) {
            NSLog(@"WGBMP4Demuxer error:%zi %@", error.code, error.localizedDescription);
        };
    }
    
    return _demuxer;
}

- (WGBAudioDecoder *)decoder {
    if (!_decoder) {
        __weak typeof(self) weakSelf = self;
        _decoder = [[WGBAudioDecoder alloc] init];
        _decoder.errorCallBack = ^(NSError *error) {
            NSLog(@"KFAudioDecoder error:%zi %@", error.code, error.localizedDescription);
        };
        // 解码数据回调。在这里把解码后的音频 PCM 数据缓冲起来等待渲染。
        _decoder.sampleBufferOutputCallBack = ^(CMSampleBufferRef sampleBuffer) {
            if (sampleBuffer) {
                CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
                size_t totolLength;
                char *dataPointer = NULL;
                CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &totolLength, &dataPointer);
                if (totolLength == 0 || !dataPointer) {
                    return;
                }
                dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
                [weakSelf.pcmDataCache appendData:[NSData dataWithBytes:dataPointer length:totolLength]];
                weakSelf.pcmDataCacheLength += totolLength;
                dispatch_semaphore_signal(weakSelf.semaphore);
            }
        };
    }
    
    return _decoder;
}

- (WGBAudioRender *)audioRender {
    if (!_audioRender) {
        __weak typeof(self) weakSelf = self;
        // 这里设置的音频声道数、采样位深、采样率需要跟输入源的音频参数一致。
        _audioRender = [[WGBAudioRender alloc] initWithChannels:1 bitDepth:16 sampleRate:44100];
        _audioRender.errorCallBack = ^(NSError* error) {
            NSLog(@"WGBAudioRender error:%zi %@", error.code, error.localizedDescription);
        };
        // 渲染输入数据回调。在这里把缓冲区的数据交给系统音频渲染单元渲染。
        _audioRender.audioBufferInputCallBack = ^(AudioBufferList * _Nonnull audioBufferList) {
            if (weakSelf.pcmDataCacheLength < audioBufferList->mBuffers[0].mDataByteSize) {
                memset(audioBufferList->mBuffers[0].mData, 0, audioBufferList->mBuffers[0].mDataByteSize);
            } else {
                dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
                memcpy(audioBufferList->mBuffers[0].mData, weakSelf.pcmDataCache.bytes, audioBufferList->mBuffers[0].mDataByteSize);
                [weakSelf.pcmDataCache replaceBytesInRange:NSMakeRange(0, audioBufferList->mBuffers[0].mDataByteSize) withBytes:NULL length:0];
                weakSelf.pcmDataCacheLength -= audioBufferList->mBuffers[0].mDataByteSize;
                dispatch_semaphore_signal(weakSelf.semaphore);
            }
        };
    }
    
    return _audioRender;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
        
    _semaphore = dispatch_semaphore_create(1);
    _pcmDataCache = [[NSMutableData alloc] init];
    
    [self setupAudioSession];
    [self setupUI];
    
    // 通过一个 timer 来保证持续从文件中解封装和解码一定量的数据。
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerCallBack:)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_timer setPaused:NO];
    
    [self.demuxer startReading:^(BOOL success, NSError * _Nonnull error) {
        NSLog(@"WGBMP4Demuxer start:%d", success);
    }];
}

- (void)dealloc {
    
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


#pragma mark - Setup
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"Audio Render";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Navigation item.
    UIBarButtonItem *startRenderBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startRender)];
    UIBarButtonItem *stopRenderBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopRender)];
    self.navigationItem.rightBarButtonItems = @[startRenderBarButton, stopRenderBarButton];
    
    self.title = @"播放带音频的文件";
    [self setupButtonWithY:120 title:@"选择媒体文件" action:@selector(getAssetsFile)];
    
}

- (void)getAssetsFile{
    [WGBFileSelectManager shareInstance].workSpaceDirName = @"AudioRender";
    [[WGBFileSelectManager shareInstance] showFilePanel];
    [[WGBFileSelectManager shareInstance] setSelectFileBlock:^(NSString * _Nonnull filePath) {
        NSLog(@"%@",filePath);
        self.demuxerConfig.asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    }];
}


#pragma mark - Action
- (void)startRender {
    [self.audioRender startPlaying];
}

- (void)stopRender {
    [self.audioRender stopPlaying];
}

#pragma mark - Utility
- (void)setupAudioSession {
    // 1、获取音频会话实例。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 2、设置分类。
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"AVAudioSession setCategory error");
    }
    
    // 3、激活会话。
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive error");
    }
}

- (void)timerCallBack:(CADisplayLink *)link {
    // 定时从文件中解封装和解码一定量（不超过 KFDecoderMaxCache）的数据。
    if (self.pcmDataCacheLength <  KFDecoderMaxCache && self.demuxer.demuxerStatus == WGBMP4DemuxerStatusRunning && self.demuxer.hasAudioSampleBuffer) {
        CMSampleBufferRef audioBuffer = [self.demuxer copyNextAudioSampleBuffer];
        if (audioBuffer) {
            [self decodeSampleBuffer:audioBuffer];
            CFRelease(audioBuffer);
        }
    }
}

- (void)decodeSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 获取解封装后的 AAC 编码裸数据。
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t totolLength;
    char *dataPointer = NULL;
    CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &totolLength, &dataPointer);
    if (totolLength == 0 || !dataPointer) {
        return;
    }
    
    // 目前 AudioDecoder 的解码接口实现的是单包（packet，1 packet 有 1024 帧）解码。而从 Demuxer 获取的一个 CMSampleBuffer 可能包含多个包，所以这里要拆一下包，再送给解码器。
    NSLog(@"SampleNum: %ld", CMSampleBufferGetNumSamples(sampleBuffer));
    for (NSInteger index = 0; index < CMSampleBufferGetNumSamples(sampleBuffer); index++) {
        // 1、获取一个包的数据。
        size_t sampleSize = CMSampleBufferGetSampleSize(sampleBuffer, index);
        CMSampleTimingInfo timingInfo;
        CMSampleBufferGetSampleTimingInfo(sampleBuffer, index, &timingInfo);
        char *sampleDataPointer = malloc(sampleSize);
        memcpy(sampleDataPointer, dataPointer, sampleSize);
        
        // 2、将数据封装到 CMBlockBuffer 中。
        CMBlockBufferRef packetBlockBuffer;
        OSStatus status = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                              sampleDataPointer,
                                                              sampleSize,
                                                              NULL,
                                                              NULL,
                                                              0,
                                                              sampleSize,
                                                              0,
                                                              &packetBlockBuffer);
        
        if (status == noErr) {
            // 3、将 CMBlockBuffer 封装到 CMSampleBuffer 中。
            CMSampleBufferRef packetSampleBuffer = NULL;
            const size_t sampleSizeArray[] = {sampleSize};
            status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                               packetBlockBuffer,
                                               CMSampleBufferGetFormatDescription(sampleBuffer),
                                               1,
                                               1,
                                               &timingInfo,
                                               1,
                                               sampleSizeArray,
                                               &packetSampleBuffer);
            CFRelease(packetBlockBuffer);
            
            // 4、解码这个包的数据。
            if (packetSampleBuffer) {
                [self.decoder decodeSampleBuffer:packetSampleBuffer];
                CFRelease(packetSampleBuffer);
            }
        }
        dataPointer += sampleSize;
    }
}

@end
