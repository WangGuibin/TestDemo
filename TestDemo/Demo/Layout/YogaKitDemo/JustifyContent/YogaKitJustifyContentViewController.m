//
// YogaKitJustifyContentViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/24
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
    

#import "YogaKitJustifyContentViewController.h"
#import "YogaJustifyContentDemoBaseViewController.h"

@interface YogaKitJustifyContentViewController ()

@end

@implementation YogaKitJustifyContentViewController


- (NSArray<Class> *)demoClassArray{
    return @[
        [YogaJustifyContentDemoBaseViewController class],
        [YogaJustifyContentDemoBaseViewController class],
        [YogaJustifyContentDemoBaseViewController class],
        [YogaJustifyContentDemoBaseViewController class],
        [YogaJustifyContentDemoBaseViewController class],
        [YogaJustifyContentDemoBaseViewController class]
    ];
}
//YGJustifyFlexStart, 居左
//YGJustifyCenter, 居中
//YGJustifyFlexEnd, 居右
//YGJustifySpaceBetween,子控件间距相等
//YGJustifySpaceAround, 边距为子控件之间的间距的二分之一
//YGJustifySpaceEvenly 所有间距相等均分 边距 = 间距
- (NSArray *)demoTitleArray{
    return @[
        @"YGJustifyFlexStart",
        @"YGJustifyCenter",
        @"YGJustifyFlexEnd",
        @"YGJustifySpaceBetween",
        @"YGJustifySpaceAround",
        @"YGJustifySpaceEvenly"
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
    YogaJustifyContentDemoBaseViewController *vc = (YogaJustifyContentDemoBaseViewController *)[[cls alloc] init];
    vc.navigationItem.title = title;
    if ([title isEqualToString:@"YGJustifyFlexStart"]) {
        vc.justifyType = YGJustifyFlexStart;
    }else if ([title isEqualToString:@"YGJustifyCenter"]){
        vc.justifyType = YGJustifyCenter;
    }else if ([title isEqualToString:@"YGJustifyFlexEnd"]){
        vc.justifyType = YGJustifyFlexEnd;
    }else if ([title isEqualToString:@"YGJustifySpaceBetween"]){
        vc.justifyType = YGJustifySpaceBetween;
    }else if ([title isEqualToString:@"YGJustifySpaceAround"]){
        vc.justifyType = YGJustifySpaceAround;
    }else if ([title isEqualToString:@"YGJustifySpaceEvenly"]){
        vc.justifyType = YGJustifySpaceEvenly;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
