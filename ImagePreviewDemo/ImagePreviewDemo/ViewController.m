//
//  ViewController.m
//  ImagePreviewDemo
//
//  Created by 王贵彬 on 2024/8/11.
//

#import "ViewController.h"
#import <GKPhotoBrowser.h>
#import <YYModel.h>
#import "GKPhotosView.h"
#import "GKTimeLineModel.h"

@interface ViewController ()<GKPhotosViewDelegate,GKPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic, copy) NSString *directryPath;
@property (nonatomic, strong) GKPhotosView *photosView;
@property (nonatomic,strong) UIScrollView *bgScrollView;

@end

@implementation ViewController

- (UIScrollView *)bgScrollView{
    if(!_bgScrollView){
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

- (NSString *)directryPath {
    if (!_directryPath) {
        NSString *basePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES).firstObject;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *directryPath = [basePath stringByAppendingPathComponent:@"uploadFile"];
        if (![fileManager fileExistsAtPath:directryPath]) {
            [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _directryPath = directryPath;
    }
    return _directryPath;
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",self.directryPath);
    
    self.photosView =  [GKPhotosView photosViewWithWidth:self.view.bounds.size.width - 20 andMargin:10];
    self.photosView.delegate = self;
    [self.bgScrollView addSubview:self.photosView];

    self.bgScrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height*2);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = [fileManager contentsOfDirectoryAtPath:self.directryPath error:nil];
        for (NSString *imgFile in paths) {
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",self.directryPath,imgFile];
            NSLog(@"%@",imagePath);
            GKTimeLineImage *imageModel = [[GKTimeLineImage alloc] init];
            imageModel.islocal = YES;
            imageModel.imageURL = [NSURL fileURLWithPath:imagePath];
            [self.models addObject:imageModel];
        }
        ///图片数量多时 发现内存会很大
        ///因为图片被提前创建解码了,而且都是原图,写入到沙盒时应该需要加一个缩略图
        for (NSInteger i = 0; i < 30; i++) {
            [self.models addObject: self.models[i%5]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosView.images = self.models;
        });
    });
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.photosView updateWidth:self.view.bounds.size.width - 20];
    CGFloat height = [GKPhotosView sizeWithCount:self.models.count width:self.view.bounds.size.width - 20 andMargin:10].height;
    self.photosView.frame = CGRectMake(10, 80, self.view.bounds.size.width - 20, height);
    self.bgScrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, height);
}


- (void)photoTapped:(UIImageView *)imgView{
    NSMutableArray *photos = [NSMutableArray array];
    [self.models enumerateObjectsUsingBlock:^(GKTimeLineImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [[GKPhoto alloc] init];
        photo.url = obj.imageURL;
        if (obj.isVideo) {
            photo.videoUrl = obj.videoURL;
        }
        photo.sourceImageView = self.photosView.subviews[idx];
        [photos addObject:photo];
    }];
    
    NSInteger index = imgView.tag;
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    browser.showStyle = GKPhotoBrowserShowStyleZoom;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask;
    browser.failStyle = GKPhotoBrowserFailStyleImageAndText;
    browser.isPopGestureEnabled = YES; // push显示，在第一页时手势返回
    [browser showFromVC:self];
    browser.delegate = self;
}


// 选择photoView时回调
- (void)photoBrowser:(GKPhotoBrowser *)browser didSelectAtIndex:(NSInteger)index{
    
}

// 单击事件
- (void)photoBrowser:(GKPhotoBrowser *)browser singleTapWithIndex:(NSInteger)index{
    
}


@end
