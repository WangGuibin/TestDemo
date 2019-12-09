//
// WGBPresentAlertDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/9
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
    

#import "WGBPresentAlertDemoViewController.h"
#import "WGBDatePickerViewController.h"
#import "WGBTitlePickerViewController.h"

@interface WGBPresentAlertDemoViewController ()

@end

@implementation WGBPresentAlertDemoViewController
- (NSArray<Class> *)demoClassArray{
    return @[
        [WGBDatePickerViewController class],
        [WGBTitlePickerViewController class]
    ];
}

- (NSArray *)demoTitleArray{
    return @[
        @"时间选择器",
        @"标题选择器"
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class cls = self.demoClassArray[indexPath.row];
    NSString *title = self.demoTitleArray[indexPath.row];
    UIViewController *vc = (UIViewController *)[[cls alloc] init];
    vc.navigationItem.title = title;
    if ([title isEqualToString:@"时间选择器"]) {
        WGBDatePickerViewController *dateVC = (WGBDatePickerViewController*)vc;
        dateVC.datePickerMode = UIDatePickerModeDateAndTime;
        dateVC.titleName = @"请选择日期";
        dateVC.dateBlock = ^(NSDate *date) {
            NSLog(@"%@", date);
        };
        [self presentViewController:dateVC animated:YES completion:^{
            
        }];
    }else if ([title isEqualToString:@"标题选择器"]){
        WGBTitlePickerViewController *titleVC = (WGBTitlePickerViewController*)vc;
        titleVC.pickerViewHeight = 180.f;
        titleVC.titleName = @"";
        titleVC.dataAry = @[@"萝莉",@"正妹",@"御姐",@"嫩模"];
        titleVC.finishBlock = ^(NSString *name, NSInteger index) {
            NSLog(@"%@", name);
        };
        [self presentViewController:titleVC animated:YES completion:^{
            
        }];
    }
}
@end
