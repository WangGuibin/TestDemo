//
//  WGBAudioDemuxerViewController.m

//
//  Created by 王贵彬 on 2023/5/10.
//

#import "WGBAudioDemuxerViewController.h"
#import "WGBMP4Demuxer.h"
#import "WGBAudioTools.h"

/// 从 mp4 中提取 aac

@interface WGBAudioDemuxerViewController ()

@property (nonatomic, strong) WGBDemuxerConfig *demuxerConfig;
@property (nonatomic, strong) WGBMP4Demuxer *demuxer;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation WGBAudioDemuxerViewController
#pragma mark - Property
- (WGBDemuxerConfig *)demuxerConfig {
    if (!_demuxerConfig) {
        _demuxerConfig = [[WGBDemuxerConfig alloc] init];
        // 只解封装音频。
        _demuxerConfig.demuxerType = WGBMediaAudio;
        // 待解封装的资源。
        NSString *assetPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
        _demuxerConfig.asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:assetPath]];
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

- (NSFileHandle *)fileHandle {
    if (!_fileHandle) {
        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"output.aac"];
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:audioPath contents:nil attributes:nil];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:audioPath];
    }

    return _fileHandle;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    // 完成音频解封装后，可以将 App Document 文件夹下面的 output.aac 文件拷贝到电脑上，使用 ffplay 播放：
    // ffplay -i output.aac
}

- (void)dealloc {
    if (_fileHandle) {
        [_fileHandle closeFile];
        _fileHandle = nil;
    }
}

#pragma mark - Setup
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"Audio Demuxer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Navigation item.
    UIBarButtonItem *startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    self.navigationItem.rightBarButtonItems = @[startBarButton];
}

#pragma mark - Action
- (void)start {
    NSLog(@"WGBMP4Demuxer start");
    __weak typeof(self) weakSelf = self;
    [self.demuxer startReading:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            // Demuxer 启动成功后，就可以从它里面获取解封装后的数据了。
            [weakSelf fetchAndSaveDemuxedData];
        } else {
            NSLog(@"WGBMP4Demuxer error: %zi %@", error.code, error.localizedDescription);
        }
    }];
}

#pragma mark - Utility
- (void)fetchAndSaveDemuxedData {
    // 异步地从 Demuxer 获取解封装后的 AAC 编码数据。
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (self.demuxer.hasAudioSampleBuffer) {
            CMSampleBufferRef audioBuffer = [self.demuxer copyNextAudioSampleBuffer];
            if (audioBuffer) {
                [self saveSampleBuffer:audioBuffer];
                CFRelease(audioBuffer);
            }
        }
        if (self.demuxer.demuxerStatus == WGBMP4DemuxerStatusCompleted) {
            NSLog(@"WGBMP4Demuxer complete");
        }
    });
}

- (void)saveSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 将解封装后的数据存储为 AAC 文件。
    if (sampleBuffer) {
        // 获取解封装后的 AAC 编码裸数据。
        AudioStreamBasicDescription streamBasicDescription = *CMAudioFormatDescriptionGetStreamBasicDescription(CMSampleBufferGetFormatDescription(sampleBuffer));
        CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
        size_t totolLength;
        char *dataPointer = NULL;
        CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &totolLength, &dataPointer);
        if (totolLength == 0 || !dataPointer) {
            return;
        }
        
        // 将 AAC 编码裸数据存储为 AAC 文件，这时候需要在每个包前增加 ADTS 头信息。
        for (NSInteger index = 0; index < CMSampleBufferGetNumSamples(sampleBuffer); index++) {
            size_t sampleSize = CMSampleBufferGetSampleSize(sampleBuffer, index);
            [self.fileHandle writeData:[WGBAudioTools adtsDataWithChannels:streamBasicDescription.mChannelsPerFrame sampleRate:streamBasicDescription.mSampleRate rawDataLength:sampleSize]];
            [self.fileHandle writeData:[NSData dataWithBytes:dataPointer length:sampleSize]];
            dataPointer += sampleSize;
        }
    }
}

@end

