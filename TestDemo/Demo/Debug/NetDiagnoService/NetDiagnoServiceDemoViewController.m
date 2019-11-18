//
// NetDiagnoServiceDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/18
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
    

#import "NetDiagnoServiceDemoViewController.h"
#import "LDNetDiagnoService.h"

@interface NetDiagnoServiceDemoViewController ()<LDNetDiagnoServiceDelegate, UITextFieldDelegate> {
    UIActivityIndicatorView *_indicatorView;
    UIButton *btn;
    UITextView *_txtView_log;
    UITextField *_txtfield_dormain;

    NSString *_logInfo;
    LDNetDiagnoService *_netDiagnoService;
    BOOL _isRunning;
}

@end

@implementation NetDiagnoServiceDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"网络诊断Demo";

    _indicatorView = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, 30, 30);
    _indicatorView.hidden = NO;
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    self.navigationItem.rightBarButtonItem = rightItem;


    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10.0f, 79.0f, 100.0f, 50.0f);
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn.titleLabel setNumberOfLines:2];
    [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
    [btn addTarget:self
                  action:@selector(startNetDiagnosis)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


    _txtfield_dormain =
        [[UITextField alloc] initWithFrame:CGRectMake(130.0f, 79.0f, 180.0f, 50.0f)];
    _txtfield_dormain.delegate = self;
    _txtfield_dormain.returnKeyType = UIReturnKeyDone;
    _txtfield_dormain.text = @"www.baidu.com";
    [self.view addSubview:_txtfield_dormain];


    _txtView_log = [[UITextView alloc] initWithFrame:CGRectZero];
    _txtView_log.layer.borderWidth = 1.0f;
    _txtView_log.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtView_log.backgroundColor = [UIColor whiteColor];
    _txtView_log.font = [UIFont systemFontOfSize:10.0f];
    _txtView_log.textAlignment = NSTextAlignmentLeft;
    _txtView_log.scrollEnabled = YES;
    _txtView_log.editable = NO;
    _txtView_log.frame =
        CGRectMake(0.0f, 140.0f, self.view.frame.size.width, self.view.frame.size.height - 120.0f);
    [self.view addSubview:_txtView_log];

    // Do any additional setup after loading the view, typically from a nib.
    _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"test"
                                                            appName:@"网络诊断应用"
                                                         appVersion:@"1.0.0"
                                                             userID:@"huipang@corp.netease.com"
                                                           deviceID:nil
                                                            dormain:_txtfield_dormain.text
                                                        carrierName:nil
                                                     ISOCountryCode:nil
                                                  MobileCountryCode:nil
                                                      MobileNetCode:nil];
    _netDiagnoService.delegate = self;
    _isRunning = NO;
}


- (void)startNetDiagnosis
{
    [_txtfield_dormain resignFirstResponder];
    _netDiagnoService.dormain = _txtfield_dormain.text;
    if (!_isRunning) {
        [_indicatorView startAnimating];
        [btn setTitle:@"停止诊断" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
        [btn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        _txtView_log.text = @"";
        _logInfo = @"";
        _isRunning = !_isRunning;
        [_netDiagnoService startNetDiagnosis];
    } else {
        [_indicatorView stopAnimating];
        _isRunning = !_isRunning;
        [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
        [btn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        [_netDiagnoService stopNetDialogsis];
    }
}

- (void)delayMethod
{
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setUserInteractionEnabled:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark NetDiagnosisDelegate
- (void)netDiagnosisDidStarted
{
    NSLog(@"开始诊断～～～");
}

- (void)netDiagnosisStepInfo:(NSString *)stepInfo
{
    NSLog(@"%@", stepInfo);
    _logInfo = [_logInfo stringByAppendingString:stepInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        _txtView_log.text = _logInfo;
    });
}


- (void)netDiagnosisDidEnd:(NSString *)allLogInfo;
{
    NSLog(@"logInfo>>>>>\n%@", allLogInfo);
    //可以保存到文件，也可以通过邮件发送回来
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicatorView stopAnimating];
        [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
        _isRunning = NO;
    });
}

- (void)emailLogInfo
{
    [_netDiagnoService printLogInfo];
}


#pragma mark -
#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
