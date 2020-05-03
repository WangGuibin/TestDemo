//
// WGBCustomWebViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/5/3
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBCustomWebViewController.h"

@interface WGBCustomWebViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableURLRequest *request;

@end

@implementation WGBCustomWebViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
        _URL = URL;
    
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString
{
    if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
    } else {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    
    NSCharacterSet *encodeSet= [NSCharacterSet URLQueryAllowedCharacterSet];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:encodeSet];

    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (void)loadView
{
    [super loadView];
    // 此处有坑，不加一个 block 处理一下（类似延迟），会出现返回按钮一直是蓝色
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createLeftBarItems];
    });
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self; 
    [self.view addSubview:self.webView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest: self.request];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc{
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)createLeftBarItems{
    UIImage * backImageNormal = [UIImage imageNamed:@"topBar_left_arrow"];
    UIImage * backImageSelect = [UIImage  imageNamed:@"topBar_left_arrow"];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 35);
    [button setImage:backImageNormal forState:UIControlStateNormal];
    [button setImage:backImageSelect forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets inset = {0,-20,0,0};
    button.imageEdgeInsets = inset;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];

    ///////////////////////////////////////
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 30, 35);
    button2.backgroundColor = [UIColor clearColor];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitle:@"关闭" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets inset2 = {0,-25,0,0};
    button2.titleEdgeInsets = inset2;
    self.closeButton = button2;
    self.closeButton.hidden = YES;
    self.closeButton.enabled = NO;
    
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:item,item2, nil];
}

- (void)onBack:(id)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)onClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//WkWebView的 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
 if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
        self.title = self.webView.title;
         } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
         }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - delegate -
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView.canGoBack) {
        self.closeButton.hidden = !self.webView.canGoBack;
        self.closeButton.enabled = self.webView.canGoBack;
    }
}




- (NSMutableURLRequest *)request {
    if (!_request) {
        _request = [[NSMutableURLRequest alloc] initWithURL:self.URL];
    }
    return _request;
}

@end
