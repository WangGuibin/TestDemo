//
//  WebCommonDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WebCommonDemoViewController.h"
#import <WebKit/WebKit.h>

#ifndef kNavBarHeight
#define kNavBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + 44)
#endif

#ifndef KWIDTH
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef KHIGHT
#define KHIGHT [UIScreen mainScreen].bounds.size.height
#endif

@interface WebCommonDemoViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) WKWebViewConfiguration *configue;
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,copy) NSString *navTitle;
@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) UIProgressView *progressView;

@end


@implementation WebCommonDemoViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, [[UIScreen mainScreen] bounds].size.width, 5)];
        _progressView.tintColor = RGB(255,123,41);
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0, 1.5);
        [self.view addSubview: _progressView];
    }
    return _progressView;
}

- (WKWebViewConfiguration *)configue {
    if (!_configue) {
        //适配网页自适应大小显示
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        _configue = [[WKWebViewConfiguration alloc] init];
        _configue.allowsInlineMediaPlayback = YES;
        _configue.userContentController = wkUController;
        if (@available(iOS 9.0, *)) {
            _configue.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
    }
    return _configue;
}


- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, KWIDTH , KHIGHT-kNavBarHeight) configuration: self.configue];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        adjustsScrollViewInsets_NO(_webView.scrollView, self);
        _webView.height -= kBottomHeight;
        [self.view addSubview: _webView];
    }
    return _webView;
}

- (NSMutableURLRequest *)request{
    if (!_request) {
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: self.url]];
        _request.timeoutInterval = 10.0f;
    }
    return _request;
}

- (instancetype)initWithURLString:(NSString *)urlStr navgationBarTitle:(NSString *)title {
    return [self initWithMethodType:WGBWebRequestTypeGET parameters: nil url:urlStr title:title];
}

/**
 统一网页接口
 @param requestType 请求的方法 GET或者POST
 @param parametersDict 参数字典
 @param url 网址
 @param title 标题
 @return 网页实例
 */
- (instancetype)initWithMethodType:(WGBWebRequestType )requestType
                        parameters:(NSDictionary *)parametersDict
                               url:(NSString *)url
                             title:(NSString *)title {
    self = [super init];
    if (self) {
        self.navTitle = title;
        if (requestType == WGBWebRequestTypeGET) {
            NSMutableString * paramStr = [NSMutableString string];
            NSArray *allKeys = parametersDict.allKeys;
            if (allKeys.count) {
                [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger index, BOOL * _Nonnull stop) {
                    if (index == 0) {
                        [paramStr appendFormat:@"%@=%@",key,parametersDict[key]];
                    }else{
                        [paramStr appendFormat:@"&%@=%@",key,parametersDict[key]];
                    }
                }];
            }
            
            if (![self.url containsString:@"?"]) {
                self.url = [NSString stringWithFormat:@"%@?%@",url,paramStr];
            }
            
        }else{
            NSString *body = [parametersDict yy_modelToJSONString];
            [self.request setHTTPMethod: @"POST"];
            [self.request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        }
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    ///监听进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest: self.request];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

///MARK:- 刚刚开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

///MARK:- 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

///MARK:- kvo监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
