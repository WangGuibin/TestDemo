//
//  WGBAudioCaptureViewController.m

//
//  Created by 王贵彬 on 2023/5/10.
//

#import "WGBAudioCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WGBAudioCapture.h"

/// 采集PCM音频流

@interface WGBAudioCaptureViewController ()

@property (nonatomic, strong) WGBAudioConfig *audioConfig;
@property (nonatomic, strong) WGBAudioCapture *audioCapture;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end


@implementation WGBAudioCaptureViewController

#pragma mark - Property
- (WGBAudioConfig *)audioConfig {
    if (!_audioConfig) {
        _audioConfig = [WGBAudioConfig defaultConfig];
    }
    
    return _audioConfig;
}

- (WGBAudioCapture *)audioCapture {
    if (!_audioCapture) {
        __weak typeof(self) weakSelf = self;
        _audioCapture = [[WGBAudioCapture alloc] initWithConfig:self.audioConfig];
        _audioCapture.errorCallBack = ^(NSError* error) {
            NSLog(@"WGBAudioCapture error: %zi %@", error.code, error.localizedDescription);
        };
        // 音频采集数据回调。在这里将 PCM 数据写入文件。
        _audioCapture.sampleBufferOutputCallBack = ^(CMSampleBufferRef sampleBuffer) {
            if (sampleBuffer) {
                // 1、获取 CMBlockBuffer，这里面封装着 PCM 数据。
                CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
                size_t lengthAtOffsetOutput, totalLengthOutput;
                char *dataPointer;
                
                // 2、从 CMBlockBuffer 中获取 PCM 数据存储到文件中。
                CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffsetOutput, &totalLengthOutput, &dataPointer);
                [weakSelf.fileHandle writeData:[NSData dataWithBytes:dataPointer length:totalLengthOutput]];
            }
        };
    }
    
    return _audioCapture;
}

- (NSFileHandle *)fileHandle {
    if (!_fileHandle) {
        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testAudio.pcm"];
        NSLog(@"PCM file path: %@", audioPath);
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:audioPath contents:nil attributes:nil];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:audioPath];
    }

    return _fileHandle;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAudioSession];
    [self setupUI];
    
    // 完成音频采集后，可以将 App Document 文件夹下面的 test.pcm 文件拷贝到电脑上，使用 ffplay 播放：
    // ffplay -ar 44100 -channels 2 -f s16le -i test.pcm
}

- (void)dealloc {
    if (_fileHandle) {
        [_fileHandle closeFile];
    }
}

#pragma mark - Setup
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"Audio Capture";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Navigation item.
    UIBarButtonItem *startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    UIBarButtonItem *stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    self.navigationItem.rightBarButtonItems = @[startBarButton, stopBarButton];

}

- (void)setupAudioSession {
    NSError *error = nil;
    
    // 1、获取音频会话实例。
    AVAudioSession *session = [AVAudioSession sharedInstance];

    // 2、设置分类和选项。
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    if (error) {
        NSLog(@"AVAudioSession setCategory error.");
        error = nil;
        return;
    }
    
    // 3、设置模式。
    [session setMode:AVAudioSessionModeVideoRecording error:&error];
    if (error) {
        NSLog(@"AVAudioSession setMode error.");
        error = nil;
        return;
    }

    // 4、激活会话。
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive error.");
        error = nil;
        return;
    }
}

#pragma mark - Action
- (void)start {
    [self.audioCapture startRunning];
}

- (void)stop {
    [self.audioCapture stopRunning];
}


@end
