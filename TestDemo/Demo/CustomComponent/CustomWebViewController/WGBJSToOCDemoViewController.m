//
// WGBJSToOCDemoViewController.m
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
    

#import "WGBJSToOCDemoViewController.h"

@interface WGBJSToOCDemoViewController ()<WKScriptMessageHandler>

@end

@implementation WGBJSToOCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"showAlert"];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"getOCMessage"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self.webView configuration].userContentController  removeScriptMessageHandlerForName:@"showAlert"];
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"getOCMessage"];

}

///MARK:- <WKScriptMessageHandler> 这种方法最为简单

/*! @abstract Invoked when a script message is received from a webpage.
 @param userContentController The user content controller invoking the
 delegate method.
 @param message The script message received.
 @code
 <!DOCTYPE html>
 <html>
     <head>
         <meta charset="utf-8" />
         <meta name="viewport" content="width=device-width, initial-scale=1">
         <title> JS与OC交互 </title>
     </head>
     <body>
         
         <button type="button" style = "font-size: 28px;" onclick="clickBtnAction()"> 点击按钮 </button>
         <script>
 
            //类似于监听OC发来的消息
            function getOCMessage(msg) {
                alert("OC -> JS : " + msg);
            }

             function clickBtnAction(){
                 var msg = "按钮被点击了,原生端弹个alert粗来吧!!!";
                 alertTips(msg);
             }
             
             function alertTips(msg){
                 window.webkit.messageHandlers.showAlert.postMessage(msg);
             }
             
         </script>
     </body>
 </html>
 @endcode
    window.webkit.messageHandlers.<#约定的方法名#>.postMessage(<#js传给原生的body参数#>);
    message.name 和 message.body, 其中body的格式 可以是NSNUmber,NSString,NSDictionary,NSArray和NSNull
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    id value = message.body;
    if ([message.name isEqualToString:@"showAlert"]) {
        NSString *msg = (NSString*)value;
        //收到JS的信息 用弹窗弹出来
        [WGBAlertTool showCommitConfirmCheckReviewTips:msg callBack:^(NSInteger index) {
            //发消息给JS alert弹出来
            [self.webView evaluateJavaScript:@"getOCMessage('你好,JS! 我是OC!!!')" completionHandler:^(id obj, NSError * _Nullable error) {
                
            }];
        }];
    }
}

#pragma mark - WKUIDelegate  对标JS的三个弹窗方法
//! alert(message)
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! confirm(message)
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! prompt(prompt, defaultText)
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text);
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKNavigationDelegate  协议拦截的交互方式
//! WKWeView在每次加载请求前会调用此方法来确认是否进行请求跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //判断协议头和解析URL携带的参数  注意: scheme会转成小写
    if ([navigationAction.request.URL.scheme isEqualToString:@"showhook"]) {
        [WGBAlertTool showCommitConfirmCheckReviewTips:navigationAction.request.URL.query callBack:^(NSInteger index) {
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


@end
