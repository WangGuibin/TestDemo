//
//  PHWebViewController.m
//  WebClipBoardDemo
//
//  Created by 王贵彬(lu.com) on 2022/1/26.
//

#import "PHWebViewController.h"
#import <WebKit/WebKit.h>
#import <Photos/Photos.h>

@interface PHWebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.frame = self.view.bounds;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
    //监听截屏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getSnapshotNote:)
                                                     name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

//监听截屏事件
- (void)getSnapshotNote:(NSNotification *)note {
    [self drawSnapshot];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"getDrawImage"];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"getLastImage"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.webView configuration].userContentController  removeScriptMessageHandlerForName:@"getDrawImage"];
    [[self.webView configuration].userContentController  removeScriptMessageHandlerForName:@"getLastImage"];

}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
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


/// 注入js调用
- (void)injectionJS:(NSString *)javascript
           callback:(void(^)(id obj,NSError*_Nullable error))callback{
    [self.webView evaluateJavaScript:javascript completionHandler:^(id obj, NSError * _Nullable error) {
        !callback? : callback(obj,error);
    }];
}


//图片转base64字符串
- (NSString *)image2Base64WithImg:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64DataString = [data base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithCarriageReturn)];
    base64DataString = [NSString stringWithFormat:@"data:image/png;base64,%@",base64DataString];
    return base64DataString;
}

//绘制截图
- (void)drawSnapshot{
    UIWindow *keywindow = [self getCurrentKeyWindow];
    UIGraphicsBeginImageContextWithOptions(keywindow.bounds.size, NO, 0);
    CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
    [keywindow drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *base64DataString = [self image2Base64WithImg:screenshotImage];
    [self injectionJS:[NSString stringWithFormat:@";loadImage('%@');",base64DataString] callback:^(id obj, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"方法名是message.name = %@ \n 参数message.body = %@",message.name,message.body);
    if ([message.name isEqualToString:@"getDrawImage"]) {
        [self drawSnapshot];
    }
    if ([message.name isEqualToString:@"getLastImage"]) {
        [self requestPhoto];
    }
}

///页面导航加载完毕
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = webView.title;
//    [self drawSnapshot];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
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
                NSString *base64DataString = [self image2Base64WithImg:[UIImage imageWithData:imageData]];
                [self injectionJS:[NSString stringWithFormat:@";loadImage('%@');",base64DataString] callback:^(id obj, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@",error.localizedDescription);
                    }
                }];                
            });
        }];
    }
}



@end
