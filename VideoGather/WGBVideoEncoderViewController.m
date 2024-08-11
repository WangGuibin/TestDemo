//
//  WGBVideoEncoderViewController.m
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import "WGBVideoEncoderViewController.h"
#import "WGBVideoCapture.h"
#import "WGBVideoEncoder.h"
#import "WGBSaveH264VideoFileTool.h"

@interface WGBVideoEncoderViewController ()
@property (nonatomic, strong) WGBVideoCaptureConfig *videoCaptureConfig;
@property (nonatomic, strong) WGBVideoCapture *videoCapture;
@property (nonatomic, strong) WGBVideoEncoderConfig *videoEncoderConfig;
@property (nonatomic, strong) WGBVideoEncoder *videoEncoder;
@property (nonatomic, assign) BOOL isEncoding;
@property (nonatomic,strong) WGBSaveH264VideoFileTool *saveFileTool;

@end


@implementation WGBVideoEncoderViewController

- (WGBSaveH264VideoFileTool *)saveFileTool{
    if(!_saveFileTool){
        _saveFileTool = [[WGBSaveH264VideoFileTool alloc] initWithFileName:@"test.h264"];
    }
    return _saveFileTool;
}

#pragma mark - Property
- (WGBVideoCaptureConfig *)videoCaptureConfig {
    if (!_videoCaptureConfig) {
        _videoCaptureConfig = [[WGBVideoCaptureConfig alloc] init];
        // 这里我们采集数据用于编码，颜色格式用了默认的：kCVPixelFormatType_420YpCbCr8BiPlanarFullRange。
    }
    return _videoCaptureConfig;
}

- (WGBVideoCapture *)videoCapture {
    if (!_videoCapture) {
        _videoCapture = [[WGBVideoCapture alloc] initWithConfig:self.videoCaptureConfig];
        __weak typeof(self) weakSelf = self;
        _videoCapture.sessionInitSuccessCallBack = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 预览渲染。
                [weakSelf.view.layer insertSublayer:weakSelf.videoCapture.previewLayer atIndex:0];
                weakSelf.videoCapture.previewLayer.backgroundColor = [UIColor blackColor].CGColor;
                weakSelf.videoCapture.previewLayer.frame = weakSelf.view.bounds;
            });
        };
        _videoCapture.sampleBufferOutputCallBack = ^(CMSampleBufferRef sampleBuffer) {
            if (weakSelf.isEncoding && sampleBuffer) {
                // 编码。
                [weakSelf.videoEncoder encodePixelBuffer:CMSampleBufferGetImageBuffer(sampleBuffer) ptsTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            }
        };
        _videoCapture.sessionErrorCallBack = ^(NSError* error) {
            NSLog(@"KFVideoCapture Error:%zi %@", error.code, error.localizedDescription);
        };
    }
    
    return _videoCapture;
}

- (WGBVideoEncoderConfig *)videoEncoderConfig {
    if (!_videoEncoderConfig) {
        _videoEncoderConfig = [[WGBVideoEncoderConfig alloc] init];
        _videoEncoderConfig.codecType = kCMVideoCodecType_H264;
        _videoEncoderConfig.profile = AVVideoProfileLevelH264HighAutoLevel;
    }
    
    return _videoEncoderConfig;
}

- (WGBVideoEncoder *)videoEncoder {
    if (!_videoEncoder) {
        _videoEncoder = [[WGBVideoEncoder alloc] initWithConfig:self.videoEncoderConfig];
        __weak typeof(self) weakSelf = self;
        _videoEncoder.sampleBufferOutputCallBack = ^(CMSampleBufferRef sampleBuffer) {
            // 保存编码后的数据。
            [weakSelf.saveFileTool saveSampleBuffer:sampleBuffer];
        };
    }
    return _videoEncoder;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation item.
    UIBarButtonItem *startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    UIBarButtonItem *stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    UIBarButtonItem *cameraBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(changeCamera)];
    self.navigationItem.rightBarButtonItems = @[stopBarButton,startBarButton,cameraBarButton];
    
    [self requestAccessForVideo];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:doubleTapGesture];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.videoCapture.previewLayer.frame = self.view.bounds;
}

- (void)dealloc {
    
}

#pragma mark - Action
- (void)start {
    NSLog(@"开始采集");
    if (!self.isEncoding) {
        self.isEncoding = YES;
        [self.videoEncoder refresh];
    }
}

- (void)stop {
    NSLog(@"停止采集");
    if (self.isEncoding) {
        self.isEncoding = NO;
        [self.videoEncoder flush];
    }
}

- (void)onCameraSwitchButtonClicked:(UIButton *)button {
    [self.videoCapture changeDevicePosition:self.videoCapture.config.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
}

- (void)changeCamera {
    NSLog(@"切换摄像头");
    [self.videoCapture changeDevicePosition:self.videoCapture.config.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender {
    [self.videoCapture changeDevicePosition:self.videoCapture.config.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
}

#pragma mark - Private Method
- (void)requestAccessForVideo{
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可。
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [weakSelf.videoCapture startRunning];
                } else {
                    // 用户拒绝。
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续。
            [weakSelf.videoCapture startRunning];
            break;
        }
        default:
            break;
    }
}

@end
