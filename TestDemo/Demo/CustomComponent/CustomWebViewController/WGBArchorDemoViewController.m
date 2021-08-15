//
// WGBArchorDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2021/6/12
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
    

#import "WGBArchorDemoViewController.h"
#import <WebKit/WebKit.h>

@interface WGBArchorDemoViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WGBArchorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
//    NSString *fileURLString = [path stringByAppendingFormat:@"#third"];
    //    NSLog(@"%@",fileURLString); // 缺少 file:// 协议头,用这个得拼协议头
//   NSString *filePath = [NSString stringByAppendingString:@"file://%@",fileURLString];
    NSURL *URL = [NSURL fileURLWithPath:path]; // # 会被转成 %23, 用这个方案得转换#
    
    // 方案① (推荐~)
    NSURL *lastURL = [NSURL URLWithString:@"#third" relativeToURL:URL];
    NSLog(@"%@",lastURL.absoluteString);
// 转成URL都是会被编码的 只能注入js去跳了~
    
    NSURLRequest *req = [NSURLRequest requestWithURL:lastURL];
    [self.webView loadRequest:req];

    // 这里延时1s 是为了加载完成再执行js  更准确的做法是在代理方法里去操作~
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //方案②
//        [self.webView evaluateJavaScript:@"window.location.hash='#second'" completionHandler:^(id _Nullable, NSError * _Nullable error) {
//        }];
        //方案③
//        [self.webView evaluateJavaScript:@"window.document.getElementById('third').scrollIntoView()" completionHandler:^(id _Nullable, NSError * _Nullable error) {
//        }];

    });

}

@end
