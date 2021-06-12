//
// WGBWebViewDemoViewController.m
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


#import "WGBWebViewDemoViewController.h"
#import "WGBCustomWebViewController.h"
#import "WGBSendArgsWebViewController.h"
#import "WGBJSToOCDemoViewController.h"
#import "WGBArchorDemoViewController.h"

@interface WGBWebViewDemoViewController ()

@end

@implementation WGBWebViewDemoViewController

- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBCustomWebViewController class],
        [WGBSendArgsWebViewController class],
        [WGBSendArgsWebViewController class],
        [WGBJSToOCDemoViewController class],
        [WGBArchorDemoViewController class],
    ];
}

- (NSArray *)demoTitleArray{
    return @[
        @"加载百度网页",
        @"加载GET请求拼接参数",
        @"加载POST请求拼接参数",
        @"JS与OC交互(JS定义方法OC调用)",
        @"本地html文件锚点处理"
    ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
        WGBCustomWebViewController *webVC = [[WGBCustomWebViewController alloc] initWithURLString:@"https://www.baidu.com"];
        [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
        
        WGBSendArgsWebViewController *webVC = [[WGBSendArgsWebViewController alloc] initWithURLString:@"https://www.baidu.com/s" argsType:(WGBWebRequestSendArgsTypeGET) parametersDict:@{@"wd":@"富婆"}];
        [self.navigationController pushViewController:webVC animated:YES];
        
        }
            break;
        case 2:
        {
        WGBSendArgsWebViewController *webVC = [[WGBSendArgsWebViewController alloc] initWithURLString:@"http://httpbin.org/post" argsType:(WGBWebRequestSendArgsTypePOST) parametersDict:@{@"myArgs":@"rich post args very good! so cool!"}];
        [self.navigationController pushViewController:webVC animated:YES];
        
        }
            break;
            
        case 3:
        {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"js2oc" ofType:@"html"];
        NSURL *URL = [NSURL fileURLWithPath:path];
        WGBJSToOCDemoViewController *webVC = [[WGBJSToOCDemoViewController alloc] initWithURL:URL];
        [self.navigationController pushViewController:webVC animated:YES];
        
        }
            break;
        case 4:
        {
        WGBArchorDemoViewController *webVC = [[WGBArchorDemoViewController alloc] init];
        [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
