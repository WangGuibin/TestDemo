//
// WGBCreateQRCodeDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/23
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
    

#import "WGBCreateQRCodeDemoViewController.h"
#import "WGBShowCodeImageDemoViewController.h"

@interface WGBCreateQRCodeDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * QRTableView;
@property (nonatomic,strong)NSArray * QRArray;

@end

@implementation WGBCreateQRCodeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.QRArray = @[@"原始二维码",@"原始条形码",@"彩色二维码",@"彩色条形码",@"渐变二维码"];
    

    self.QRTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.QRTableView.delegate =self;
    self.QRTableView.dataSource = self;
    [self.view addSubview:self.QRTableView];
    self.QRTableView.tableFooterView = [UIView new];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.QRArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text =self.QRArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WGBShowCodeImageDemoViewController * QRCode = [[WGBShowCodeImageDemoViewController alloc]init];
    QRCode.type = indexPath.row;
    QRCode.QRTitle = self.QRArray[indexPath.row]; 
    [self.navigationController pushViewController:QRCode animated:YES];
}



@end
