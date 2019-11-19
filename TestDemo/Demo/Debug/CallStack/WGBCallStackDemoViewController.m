//
// WGBCallStackDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/19
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
    

#import "WGBCallStackDemoViewController.h"
#import <execinfo.h>

@interface WGBCallStackDemoViewController ()

@property (nonatomic, strong) NSMutableString *strM;
@property (nonatomic, strong) NSMutableArray *callStackArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cleanButton;

@end

@implementation WGBCallStackDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 200 , 44);
    button.centerX = self.view.bounds.size.width/2.0;
    [button setTitle:@"获取堆栈日志" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    ViewRadius(button, 22);
    [button addTarget:self action:@selector(getCallStackInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
    
    self.textView.frame = CGRectMake(0, 150, KWIDTH , KHIGHT - 150);
    self.cleanButton.frame = CGRectMake(KWIDTH - 110, 150, 100 , 30);
}

- (void)getCallStackInfo{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    self.callStackArray = [NSMutableArray arrayWithCapacity:frames];
    for ( i = 0 ; i < frames ; i++ ){
        [self.callStackArray addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    NSLog(@"\n %@ \n",self.callStackArray);
    NSString *callStackStr = [self.callStackArray componentsJoinedByString:@"\n"];
    [self.strM appendFormat:@"\n\n"];
    [self.strM insertString:[NSString stringWithFormat:@"\n\n%@",callStackStr] atIndex:0];
    self.textView.text = self.strM;
}

- (void)clearScreenAction{
    self.textView.text = nil;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
        _textView.textColor = [[UIColor greenColor] colorWithAlphaComponent:0.65];
        _textView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_textView];
    }
    return _textView;
}


- (NSMutableString *)strM {
    if (!_strM) {
        _strM = [[NSMutableString alloc] init];
    }
    return _strM;
}

- (UIButton *)cleanButton {
    if (!_cleanButton) {
        _cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cleanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _cleanButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cleanButton setTitle:@"清屏" forState:UIControlStateNormal];
         [_cleanButton addTarget:self action:@selector(clearScreenAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cleanButton];
     }
    return _cleanButton;
}

@end
