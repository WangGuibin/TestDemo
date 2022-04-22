//
//  ViewController.m
//  WebClipBoardDemo
//
//  Created by 王贵彬(lu.com) on 2022/1/26.
//

#import "ViewController.h"
#import "PHWebViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    [self setupButtonWithY:80 title:@"测试web" action:@selector(webPageAction)];
    [self setupButtonWithY:140 title:@"获取相册最新的图片" action:@selector(requestPhoto)];
    [self setupButtonWithY:200 title:@"重新绘制截图" action:@selector(drawSnapshotAction)];
    
    //监听截屏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getSnapshotNote:)
                                                     name:UIApplicationUserDidTakeScreenshotNotification object:nil];

}

- (void)getSnapshotNote:(NSNotification *)note {
    NSLog(@"检测到用户截屏了~");
    //存到相册需要点延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestPhoto];
    });
}

/// 直接自己画一个 兼容iOS 7.0以上
- (void)drawSnapshotAction{
    UIWindow *keywindow = [self getCurrentKeyWindow];
    UIGraphicsBeginImageContextWithOptions(keywindow.bounds.size, NO, 0);
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    [keywindow drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = screenshotImage;
}

- (void)webPageAction{
    PHWebViewController *webVC = [PHWebViewController new];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (UIWindow *)getCurrentKeyWindow{
    if([[[UIApplication sharedApplication] delegate] window]) {
        return [[[UIApplication sharedApplication] delegate] window];
    }else{
        if(@available(iOS 13.0, *)) {
            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene* windowScene = (UIWindowScene*)array[0];
            //如果是App开发，可以使用
//            SceneDelegate * delegate = (SceneDelegate *)windowScene.delegate;
//            UIWindow * mainWindow = delegate.window;
            //由于在sdk开发中，引入不了SceneDelegate的头文件，所以需要用kvc获取宿主app的window.
            UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow) {
                return mainWindow;
            }else{
                return[UIApplication sharedApplication].windows.lastObject;
            }
        }else{
            // Fallback on earlier versions
            return[UIApplication sharedApplication].keyWindow;
        }
    }
}

- (void)requestPhoto{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        //弹窗
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"未得到您的允许,读取您的相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];

        UIAlertAction * action = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertC addAction:action];

    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        [self getLastPhoto];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                 [self getLastPhoto];
            }
        }];
    }
}

/// 获取相册最新的一张图
- (void)getLastPhoto{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHAsset *phasset = [assetsFetchResults lastObject];
    if (phasset && phasset.mediaType == PHAssetMediaTypeImage) {
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestImageDataAndOrientationForAsset:phasset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:imageData];
            });
        }];
    }
}


@end
